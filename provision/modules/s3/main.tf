resource "aws_s3_bucket" "tf-state" {
  bucket = "tf-state-sample"
  versioning {
    enabled = true
  }
}
