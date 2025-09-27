variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "availability_zones" {
  type = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.10.1.0/24"
}

variable "private_app_subnet_cidr" {
  type    = string
  default = "10.10.2.0/24"
}

variable "private_rds_subnet_cidr" {
  type    = string
  default = "10.10.3.0/24"
}

variable "key_name" {
  type = string
}

variable "ami_id" {
  type        = string
  description = "AMI ID for EC2 instances (e.g., Amazon Linux 2 or Ubuntu)"
}

variable "web_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "app_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_engine_version" {
  type    = string
  default = "8.0"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
