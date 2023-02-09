resource "aws_s3_bucket" "bucket" {
  bucket = "chaitanya-terraform-state-backend"
  acl    = "private"
  versioning {
    enabled = false
  }
}

resource "aws_s3_bucket_object" "folder1" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
  key    = "state/"
}

resource "aws_dynamodb_table" "state_locking" {
  hash_key = "LockID"
  name     = "terraform-lock"
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"
}