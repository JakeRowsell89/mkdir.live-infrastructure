resource "aws_s3_bucket" "uploads" {
  bucket = "mkdir.live-uploads"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "UploadsBucketPolicyGetObject",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "${aws_iam_role.lambda_move_uploads.arn}"
                ]
            },
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::mkdir.live-uploads/*"
            ]
        }
    ]
}
POLICY
}

resource "aws_s3_bucket" "functions" {
  bucket = "mkdir.live-functions"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "FunctionsBucketPolicyGetObject",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "${aws_iam_role.lambda_move_uploads.arn}"
                ]
            },
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::mkdir.live-functions/*"
            ]
        }
    ]
}
POLICY
}
resource "aws_s3_bucket" "static" {
  bucket = "mkdir.live-static"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "StaticBucketPolicyGetObject",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "${aws_iam_role.lambda_move_uploads.arn}"
                ]
            },
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::mkdir.live-static/*"
            ]
        }
    ]
}
POLICY
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket = "mkdir.live-cloudtrail"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCloudTrailGetBucketACL",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::mkdir.live-cloudtrail"
        },
        {
            "Sid": "AllowCloudTrailPutObject",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::mkdir.live-cloudtrail/AWSLogs/236744700502/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}