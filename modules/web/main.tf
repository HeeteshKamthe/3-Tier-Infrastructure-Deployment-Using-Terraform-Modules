# Security group for web
resource "aws_security_group" "web_sg" {
  name   = "web-sg"
  vpc_id = var.vpc_id
  description = "Allow HTTP, HTTPS, SSH"
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Optional: SSH (adjust to a trusted IP for production)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "web-sg" }
}

# Web EC2 (public)
resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

#  user_data = <<-EOF
#              #!/bin/bash
#              yum update -y
#              yum install -y httpd
#              systemctl enable httpd
#              systemctl start httpd
#              echo "Hello from web tier" > /var/www/html/index.html
#              EOF

  tags = { Name = "web-instance" }
}