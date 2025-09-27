module "vpc" {
  source = "./modules/vpc"

  vpc_cidr                = var.vpc_cidr
  availability_zones      = var.availability_zones
  public_subnet_cidr      = var.public_subnet_cidr
  private_app_subnet_cidr = var.private_app_subnet_cidr
  private_rds_subnet_cidr = var.private_rds_subnet_cidr
}

module "web" {
  source = "./modules/web"

  vpc_id          = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  ami_id          = var.ami_id
  instance_type   = var.web_instance_type
  key_name        = var.key_name
}

module "app" {
  source = "./modules/app"

  vpc_id           = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_app_subnet_id
  ami_id           = var.ami_id
  instance_type    = var.app_instance_type
  key_name         = var.key_name

  web_sg_id        = module.web.web_sg_id
}

module "rds" {
  source = "./modules/rds"

  vpc_id             = module.vpc.vpc_id
  db_subnet_ids      = [module.vpc.private_app_subnet_id,module.vpc.private_rds_subnet_id]
  allocated_storage  = var.db_allocated_storage
  engine             = var.db_engine
  engine_version     = var.db_engine_version
  username           = var.db_username
  password           = var.db_password

  allowed_source_security_group_id = module.app.app_sg_id
}


resource "tls_private_key" "example_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create an AWS EC2 Key Pair using the generated public key
resource "aws_key_pair" "example_key_pair" {
  key_name   = "my-key"
  public_key = tls_private_key.example_key.public_key_openssh
}
 
# Save the private key to a local file
resource "local_file" "example_private_key" {
  content  = tls_private_key.example_key.private_key_pem
  filename = "my-key.pem"
  file_permission = "0400"
}