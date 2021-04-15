
resource "aws_cloudwatch_event_rule" "trigger_on_upload" {
  name = "mkdir.live-upload"

  event_pattern = templatefile("./cloudwatch-event-pattern.json", { bucket_name = aws_s3_bucket.uploads.bucket })
}

# resource "aws_cloudwatch_event_target" "platform-bills-checker" {
#   rule     = aws_cloudwatch_event_rule.platform-bills-checker.name
#   arn      = aws_
#   role_arn = "arn:aws:iam::${local.account.id}:role/platform-bills-checker-cloudwatch-${local.environment}"
# }

resource "aws_cloudwatch_log_group" "lambda_get_presigned_url" {
  name              = "/aws/lambda/get-presigned-url"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "api_gateway_get_presigned_url" {
  name              = "/aws/apigateway/get-presigned-url"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "s3_upload_file" {
  name              = "/aws/s3/upload-file"
  retention_in_days = 14
}