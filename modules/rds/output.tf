output "db_endpoint" {
  value = aws_db_instance.db.endpoint
}
output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}