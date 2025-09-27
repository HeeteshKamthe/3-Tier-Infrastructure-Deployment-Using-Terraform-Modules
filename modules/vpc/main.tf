resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "three-tier-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = { Name = "three-tier-igw" }
}

# Public subnet in AZ 0
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet" }
}

# Private app subnet in AZ 1
resource "aws_subnet" "private_app" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_app_subnet_cidr
  availability_zone = var.availability_zones[1]
  map_public_ip_on_launch = false
  tags = { Name = "private-app-subnet" }
}

# Private rds subnet in AZ 2
resource "aws_subnet" "private_rds" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_rds_subnet_cidr
  availability_zone = var.availability_zones[2]
  map_public_ip_on_launch = false
  tags = { Name = "private-rds-subnet" }
}

# Elastic IP for NAT
resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id
  tags = { Name = "nat-gateway" }
  depends_on = [aws_eip.nat_eip]
}

# Route tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "private-rt" }
}

resource "aws_route_table_association" "private_app_assoc" {
  subnet_id      = aws_subnet.private_app.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_rds_assoc" {
  subnet_id      = aws_subnet.private_rds.id
  route_table_id = aws_route_table.private_rt.id
}
