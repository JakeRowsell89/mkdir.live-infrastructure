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

resource "aws_lambda_function" "move_static_site" {
  filename         = "./lambdas/move-static-site.zip"
  function_name    = "move-static-site"
  role             = aws_iam_role.lambda_move_static_site.arn
  handler          = "move-static-site/index.handler"
  source_code_hash = filebase64sha256("./lambdas/move-static-site.zip")
  runtime          = "nodejs14.x"
  timeout          = 30
  depends_on = [
    aws_cloudwatch_log_group.lambda_move_static_site
  ]
}

resource "aws_lambda_function" "move_function" {
  filename         = "./lambdas/move-function.zip"
  function_name    = "move-function"
  role             = aws_iam_role.lambda_move_function.arn
  handler          = "move-function/index.handler"
  source_code_hash = filebase64sha256("./lambdas/move-function.zip")
  runtime          = "nodejs14.x"
  timeout          = 15
  depends_on = [
    aws_cloudwatch_log_group.lambda_move_function
  ]
}

resource "aws_lambda_permission" "lambda_move_static_site_cloudwatch_trigger" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.move_static_site.function_name
  principal     = "events.amazonaws.com"
  #   source_arn    = "${aws_apigatewayv2_api.signed_s3_urls.arn}/*/*/*" NOT working, revisit
}

resource "aws_lambda_permission" "lambda_move_function_cloudwatch_trigger" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.move_function.function_name
  principal     = "events.amazonaws.com"
  #   source_arn    = "${aws_apigatewayv2_api.signed_s3_urls.arn}/*/*/*" NOT working, revisit
}

resource "aws_lambda_function" "create_lambdas" {
  filename         = "./lambdas/create-lambdas.zip"
  function_name    = "create-functions"
  role             = aws_iam_role.lambda_create_lambdas.arn
  handler          = "create-lambdas/index.handler"
  source_code_hash = filebase64sha256("./lambdas/create-lambdas.zip")
  runtime          = "nodejs14.x"
  timeout          = 15
}

resource "aws_lambda_permission" "lambda_create_lambdas_cloudwatch_trigger" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_lambdas.function_name
  principal     = "events.amazonaws.com"
  #   source_arn    = "${aws_apigatewayv2_api.signed_s3_urls.arn}/*/*/*" NOT working, revisit
}
