output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_app_subnet_id" {
  value = module.vpc.private_app_subnet_id
}

output "private_rds_subnet_id" {
  value = module.vpc.private_rds_subnet_id
}

output "web_instance_public_ip" {
  value = module.web.web_public_ip
}

output "web_sg_id" {
  value = module.web.web_sg_id
}

output "app_instance_private_ip" {
  value = module.app.app_private_ip
}

output "app_sg_id" {
  value = module.app.app_sg_id
}

output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "rds_sg_id" {
  value = module.rds.rds_sg_id
}
