terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-south-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "narendar-terraform-test-bucket"
}

output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}
