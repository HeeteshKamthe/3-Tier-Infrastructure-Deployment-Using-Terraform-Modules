variable "vpc_cidr" { type = string }
variable "availability_zones" { type = list(string) }
variable "public_subnet_cidr" { type = string }
variable "private_app_subnet_cidr" { type = string }
variable "private_rds_subnet_cidr" { type = string }
