# VPC
output "vpc_id" {
  value = module.vpc.vpc_id
}

# EC2
output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "ec2_public_dns" {
  value = module.ec2.instance_dns
}

# S3
output "documents_bucket_name" {
  value = module.s3.bucket_name
}

# RDS
output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "rds_port" {
  value = module.rds.db_port
}

# CloudWatch
output "sns_topic_arn" {
  value = module.cloudwatch.sns_topic_arn
}