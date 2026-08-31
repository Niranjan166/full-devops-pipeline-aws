terraform {
  backend "s3" {
    bucket         = "dms-niru-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dms-terraform-lock"
    encrypt        = true
  }
}