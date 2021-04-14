resource "aws_lambda_function" "get_presigned_url" {
  filename         = "./lambdas/presign-urls.zip"
  function_name    = "get-presigned-url"
  role             = aws_iam_role.lambda_presign_urls.arn
  handler          = "presign-urls/index.handler"
  source_code_hash = filebase64sha256("./lambdas/presign-urls.zip")
  runtime          = "nodejs14.x"
  timeout          = 10
  depends_on = [
    aws_cloudwatch_log_group.lambda_get_presigned_url
  ]
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_presigned_url.function_name
  principal     = "apigateway.amazonaws.com"
  #   source_arn    = "${aws_apigatewayv2_api.signed_s3_urls.arn}/*/*/*" NOT working, revisit
}

resource "aws_lambda_function" "move_uploads" {
  filename         = "./lambdas/move-uploads.zip"
  function_name    = "move-uploads"
  role             = aws_iam_role.lambda_move_uploads.arn
  handler          = "move-uploads/index.handler"
  source_code_hash = filebase64sha256("./lambdas/move-uploads.zip")
  runtime          = "nodejs14.x"
}

resource "aws_lambda_function" "create_lambdas" {
  filename         = "./lambdas/create-lambdas.zip"
  function_name    = "create-functions"
  role             = aws_iam_role.lambda_create_lambdas.arn
  handler          = "create-lambdas/index.handler"
  source_code_hash = filebase64sha256("./lambdas/create-lambdas.zip")
  runtime          = "nodejs14.x"
}