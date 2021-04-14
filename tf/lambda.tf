resource "aws_lambda_function" "get-presigned-url" {
  filename         = "./lambdas/presign-urls.zip"
  function_name    = "get-presigned-url"
  role             = aws_iam_role.lambda_presign_urls.arn
  handler          = "presign-urls/index.handler"
  source_code_hash = filebase64sha256("./lambdas/presign-urls.zip")
  runtime          = "nodejs14.x"
}

resource "aws_lambda_function" "move-uploads" {
  filename         = "./lambdas/move-uploads.zip"
  function_name    = "move-uploads"
  role             = aws_iam_role.lambda_move_uploads.arn
  handler          = "move-uploads/index.handler"
  source_code_hash = filebase64sha256("./lambdas/move-uploads.zip")
  runtime          = "nodejs14.x"
}

resource "aws_lambda_function" "create-lambdas" {
  filename         = "./lambdas/create-lambdas.zip"
  function_name    = "create-functions"
  role             = aws_iam_role.lambda_create_lambdas.arn
  handler          = "create-lambdas/index.handler"
  source_code_hash = filebase64sha256("./lambdas/create-lambdas.zip")
  runtime          = "nodejs14.x"
}