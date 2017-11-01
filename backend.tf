terraform {
  backend "s3" {
    bucket = "soroco-terraform-tfstate"
    key    = "PROD/terraform.tfstate"
    region = "us-east-1"
  }
}
