
resource "aws_cloudwatch_event_rule" "trigger_on_static_site_upload" {
  name = "mkdir.live-upload-static-site"

  event_pattern = templatefile("./cloudwatch-event-pattern.json", { bucket_name = aws_s3_bucket.uploads.bucket, folder = "static" })
}

resource "aws_cloudwatch_event_rule" "trigger_on_function_upload" {
  name = "mkdir.live-upload-function"

  event_pattern = templatefile("./cloudwatch-event-pattern.json", { bucket_name = aws_s3_bucket.uploads.bucket, folder = "functions" })
}

resource "aws_cloudwatch_event_rule" "trigger_on_function_move" {
  name = "mkdir.live-move-function"

  event_pattern = templatefile("./cloudwatch-event-pattern.json", { bucket_name = aws_s3_bucket.functions.bucket, folder = "functions" })
}

resource "aws_cloudwatch_event_target" "lambda_move_static_site" {
  rule = aws_cloudwatch_event_rule.trigger_on_static_site_upload.name
  arn  = aws_lambda_function.move_static_site.arn
}

resource "aws_cloudwatch_event_target" "lambda_move_function" {
  rule = aws_cloudwatch_event_rule.trigger_on_function_upload.name
  arn  = aws_lambda_function.move_function.arn
}

resource "aws_cloudwatch_event_target" "lambda_create_function" {
  rule = aws_cloudwatch_event_rule.trigger_on_function_move.name
  arn  = aws_lambda_function.create_lambdas.arn
}

resource "aws_cloudwatch_log_group" "lambda_get_presigned_url" {
  name              = "/aws/lambda/get-presigned-url"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "lambda_move_static_site" {
  name              = "/aws/lambda/move-static-site"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "lambda_move_function" {
  name              = "/aws/lambda/move-function"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "api_gateway_get_presigned_url" {
  name              = "/aws/apigateway/get-presigned-url"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "create_lambda_and_route" {
  name              = "/aws/lambda/create-functions"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "api_gateway_access_uploaded_functions" {
  name              = "/aws/apigateway/access-uploaded-functions"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "s3_upload_file" {
  name              = "/aws/s3/upload-file"
  retention_in_days = 1
}
