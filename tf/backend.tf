terraform {
  backend "s3" {
    bucket  = "mkdir.live-terraform-state"
    key     = "tfstate"
    encrypt = true
    acl     = "bucket-owner-full-control"
    region  = "eu-west-2"
  }
}