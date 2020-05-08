provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "db_access" {
  name   = "db_access"
  vpc_id = aws_default_vpc.default.id

  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "database" {
  allocated_storage      = 8
  storage_type           = "standard"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "asmo"
  username               = "asmo"
  password               = "asmodatabase123" # I know...
  vpc_security_group_ids = [aws_security_group.db_access.id]
  publicly_accessible    = true
  skip_final_snapshot    = true
}


# The buckets use a canned ACL set to "public-read" based on the assumption
# that these assets will be served to the end-user directly from S3 and there
# is no problem in making them public.

resource "aws_s3_bucket" "legacy_bucket" {
  bucket = "asmo-bucket-legacy"
  acl    = "public-read"
}

resource "aws_s3_bucket" "modern_bucket" {
  bucket = "asmo-bucket-modern"
  acl    = "public-read"
}
