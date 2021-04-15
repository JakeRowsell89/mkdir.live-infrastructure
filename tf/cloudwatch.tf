
resource "aws_cloudwatch_event_rule" "trigger_on_upload" {
  name = "mkdir.live-upload"

  event_pattern = templatefile("./cloudwatch-event-pattern.json", { bucket_name = aws_s3_bucket.uploads.bucket })
}

resource "aws_cloudwatch_event_target" "lambda_move_uploads" {
  rule = aws_cloudwatch_event_rule.trigger_on_upload.name
  arn  = aws_lambda_function.move_uploads.arn
}

resource "aws_cloudwatch_log_group" "lambda_get_presigned_url" {
  name              = "/aws/lambda/get-presigned-url"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "lambda_move_uploads" {
  name              = "/aws/lambda/move-uploads"
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