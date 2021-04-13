resource "aws_s3_bucket" "uploads" {
  bucket = "mkdir.live-uploads"
  policy = file("./policies/bucket-uploads.json")
}

resource "aws_s3_bucket" "functions" {
  bucket = "mkdir.live-functions"
  #   policy = file("policy-functions.json")
}

resource "aws_s3_bucket" "static" {
  bucket = "mkdir.live-static"
  #   policy = file("policy-static.json")
}