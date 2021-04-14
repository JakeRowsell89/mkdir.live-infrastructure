resource "aws_iam_role" "lambda_move_uploads" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "lambda_move_uploads" {
  name = "lambda_move_uploads"
  role = aws_iam_role.lambda_move_uploads.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:GetObject"
        Effect   = "Allow"
        Sid      = ""
        Resource = "arn:aws:s3:::mkdir.live-uploads"
      },
      {
        Action = "s3:PutObject"
        Effect = "Allow"
        Sid    = ""
        Resource = [
          "arn:aws:s3:::mkdir.live-functions",
          "arn:aws:s3:::mkdir.live-static"
        ]
      },
      {
        "Effect" = "Allow"
        "Action" = [
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeNetworkInterface"
        ],
        "Resource" = "*"
      }
    ]
  })
}

resource "aws_iam_role" "lambda_presign_urls" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "lambda_presign_urls" {
  name = "lambda_presign_urls"
  role = aws_iam_role.lambda_presign_urls.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Even though the Lambda won't call PutObject
        # it needs the permission for it's pre-signed URL to be valid
        Action   = "s3:PutObject"
        Effect   = "Allow"
        Sid      = ""
        Resource = "arn:aws:s3:::mkdir.live-uploads/*"
      },
      {
        "Effect" = "Allow"
        "Action" = [
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeNetworkInterface"
        ],
        "Resource" = "*"
      },
      {
        "Action" = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        "Resource" = "arn:aws:logs:*:*:*"
        "Effect"   = "Allow"
      },
    ]
  })
}

resource "aws_iam_role" "lambda_create_lambdas" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "lambda_create_lambdas" {
  name = "lambda_create_lambdas"
  role = aws_iam_role.lambda_create_lambdas.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" = "Allow"
        "Action" = [
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeNetworkInterface"
        ],
        "Resource" = "*"
      }
    ]
  })
}

resource "aws_iam_role" "cloudwatch_logs" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "cloudwatch_allow_logging" {
  name = "cloudwatch_allow_logging"
  role = aws_iam_role.cloudwatch_logs.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" = "Allow"
        "Action" = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents",
        ]
        "Resource" = "*"
      }
    ]
  })
}

resource "aws_iam_role" "api_gateway_put_object" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "api_gateway_put_object" {
  name = "api-gateway-put-object"
  role = aws_iam_role.api_gateway_put_object.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:PutObject"
        Effect   = "Allow"
        Sid      = ""
        Resource = "arn:aws:s3:::mkdir.live-uploads"
      }
    ]
  })
}