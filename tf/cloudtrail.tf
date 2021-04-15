resource "aws_cloudtrail" "log_put_objects" {
  name                          = "mkdir.live-cloudtrail"
  s3_bucket_name                = "mkdir.live-cloudtrail"
  s3_key_prefix                 = ""
  include_global_service_events = false

  event_selector {
    read_write_type           = "WriteOnly"
    include_management_events = false

    data_resource {
      type = "AWS::S3::Object"
      values = [
        "${aws_s3_bucket.uploads.arn}/",
        "${aws_s3_bucket.functions.arn}/"
      ]
    }
  }
  cloud_watch_logs_role_arn  = aws_iam_role.cloudwatch_logs.arn
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.s3_upload_file.arn}:*"
}