# S3 Bucket

# Create an S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "swiggy-s3-bucket-gout-7989"
}

# Enable versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
