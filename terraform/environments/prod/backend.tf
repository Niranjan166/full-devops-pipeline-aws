terraform {
  backend "s3" {
    bucket         = "dms-nitesh-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dms-terraform-lock"
    encrypt        = true
  }
}