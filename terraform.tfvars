aws_region              = "ap-southeast-2"
availability_zones      = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]

vpc_cidr                = "10.10.0.0/16"
public_subnet_cidr      = "10.10.1.0/24"
private_app_subnet_cidr = "10.10.2.0/24"
private_rds_subnet_cidr = "10.10.3.0/24"

key_name = "my-key"

# Example: Amazon Linux 2 AMI for ap-southeast-2
ami_id   = "ami-010876b9ddd38475e"

db_username = "dbadmin"
db_password = "pass1234"
