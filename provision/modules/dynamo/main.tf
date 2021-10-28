resource "aws_dynamodb_table" "tf-state-lock" {
  name = "tf-state-lock-sample-db"
  read_capacity = 1
  write_capacity = 1
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Service     = var.service
  }
}
