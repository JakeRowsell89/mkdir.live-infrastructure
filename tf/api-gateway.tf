resource "aws_apigatewayv2_api" "signed_s3_urls" {
  name          = "signed-s3-urls"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "get_signed_url" {
  api_id           = aws_apigatewayv2_api.signed_s3_urls.id
  integration_type = "AWS_PROXY"

  connection_type        = "INTERNET"
  payload_format_version = "2.0"
  description            = "Get a signed S3 URL from a Lambda function"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.get_presigned_url.invoke_arn
}

resource "aws_apigatewayv2_stage" "get_signed_urls" {
  api_id      = aws_apigatewayv2_api.signed_s3_urls.id
  name        = "$default"
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_get_presigned_url.arn
    format          = "{ \"integrationError\":\"$context.integration.error\", \"requestId\":\"$context.requestId\", \"ip\": \"$context.identity.sourceIp\", \"caller\":\"$context.identity.caller\", \"user\":\"$context.identity.user\", \"requestTime\":\"$context.requestTime\", \"httpMethod\":\"$context.httpMethod\", \"resourcePath\":\"$context.resourcePath\", \"status\":\"$context.status\", \"protocol\":\"$context.protocol\", \"responseLength\":\"$context.responseLength\", \"error\":\"$context.error.message\" }"
  }
}

resource "aws_apigatewayv2_route" "get_signed_url_static" {
  api_id    = aws_apigatewayv2_api.signed_s3_urls.id
  route_key = "GET /static"
  target    = "integrations/${aws_apigatewayv2_integration.get_signed_url.id}"
}

resource "aws_apigatewayv2_route" "get_signed_url_function" {
  api_id    = aws_apigatewayv2_api.signed_s3_urls.id
  route_key = "GET /function"
  target    = "integrations/${aws_apigatewayv2_integration.get_signed_url.id}"
}

resource "aws_api_gateway_account" "mkdir_live" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch_logs.arn
}

resource "aws_apigatewayv2_api" "access_uploaded_functions" {
  name          = "access-uploaded-functions"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.access_uploaded_functions.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_access_uploaded_functions.arn
    format          = "{ \"integrationError\":\"$context.integration.error\", \"requestId\":\"$context.requestId\", \"ip\": \"$context.identity.sourceIp\", \"caller\":\"$context.identity.caller\", \"user\":\"$context.identity.user\", \"requestTime\":\"$context.requestTime\", \"httpMethod\":\"$context.httpMethod\", \"resourcePath\":\"$context.resourcePath\", \"status\":\"$context.status\", \"protocol\":\"$context.protocol\", \"responseLength\":\"$context.responseLength\", \"error\":\"$context.error.message\" }"
  }
}