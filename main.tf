provider "aws" {
  region = var.region
}
terraform {
  backend "s3" {
    bucket = "itjuana-nuvve-mendiart"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
