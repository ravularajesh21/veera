terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.67.0" # AWS provider version, not terraform version
    }
  }

  backend "s3" {
    bucket = "razesh"
    key    = "vpc-test"
    region = "us-east-1"
    dynamodb_table = "veera"
  }
}

provider "aws" {
  region = "us-east-1"
}