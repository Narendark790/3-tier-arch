resource "aws_s3_bucket" "example" {
  bucket = "narendar-terraform-test-bucket"
}

output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}
