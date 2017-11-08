provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "vbterraformstate"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "StateLock"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "vbterraformstate"
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = true
  }
}


resource "aws_dynamodb_table" "terraform_statelock" {
  name           = "StateLock"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

