terraform {
  backend "s3" {
    bucket = "hdfclife-tfstat"
    key    = "PROD/terraform.tfstate"
    region = "ap-south-1"
  }
}
