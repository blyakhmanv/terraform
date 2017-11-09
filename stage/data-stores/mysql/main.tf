provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "vbterraformstate"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "StateLock"
  }
}

resource "aws_db_instance" "example" {
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  name = "example_database"
  username = "admin"
  password = "${var.db_password}"
  skip_final_snapshot = true
}