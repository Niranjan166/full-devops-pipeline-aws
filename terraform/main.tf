module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment

  vpc_cidr = var.vpc_cidr
  az_count = var.az_count
}

#main.tf is the root module that invokes reusable child modules and passes the environment specific variables into them.

module "ec2" {
  source = "./modules/ec2"

  project_name = var.project_name
  environment  = var.environment

  public_subnet_ids = module.vpc.public_subnet_ids

  ec2_security_group_id = module.vpc.ec2_security_group_id

  instance_type             = var.instance_type
  key_pair_name             = var.key_pair_name
  iam_instance_profile_name = module.iam.instance_profile_name
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
}

module "s3" {
  source = "./modules/s3"

  project_name   = var.project_name
  environment    = var.environment
  lifecycle_days = var.lifecycle_days
}

module "rds" {
  source = "./modules/rds"

  project_name = var.project_name
  environment  = var.environment

  private_subnet_ids    = module.vpc.private_subnet_ids
  rds_security_group_id = module.vpc.rds_security_group_id

  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  db_instance_class = var.db_instance_class
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  project_name = var.project_name
  environment  = var.environment

  instance_id            = module.ec2.instance_id
  db_instance_identifier = module.rds.db_identifier

  alert_email = var.alert_email
}