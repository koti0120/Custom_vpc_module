terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "expense-remote-dev"
    key            = "koti-vpc"
    region         = "us-east-1"
    dynamodb_table = "expense-locking"
  }
}
provider "aws" {
  region = "us-east-1"
}