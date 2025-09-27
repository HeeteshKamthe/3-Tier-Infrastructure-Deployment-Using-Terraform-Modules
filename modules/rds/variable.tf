variable "vpc_id" { type = string }
variable "db_subnet_ids" { type = list(string) }
variable "allocated_storage" { type = number }
variable "engine" { type = string }
variable "engine_version" { type = string }
variable "username" { type = string }
variable "password" { type = string }
variable "allowed_source_security_group_id" { type = string }