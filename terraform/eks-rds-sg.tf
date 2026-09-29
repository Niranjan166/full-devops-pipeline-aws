resource "aws_vpc_security_group_ingress_rule" "eks_to_rds_mysql" {
  security_group_id            = module.vpc.rds_security_group_id
  referenced_security_group_id = module.eks.cluster_security_group_id

  from_port   = 3306
  to_port     = 3306
  ip_protocol = "tcp"

  description = "Allow MySQL access from EKS cluster"
}
