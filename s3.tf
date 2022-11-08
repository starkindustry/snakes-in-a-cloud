resource "aws_s3_bucket" "app_src_bucket" {
  bucket = "snakes-in-a-cloud-${terraform.workspace}"
}

resource "aws_s3_object" "flask_app_bundle" {
  bucket = aws_s3_bucket.app_src_bucket.id
  key    = "beanstalk/flask_app_v1.zip"
  source = "flask_app_v1.zip"
}
