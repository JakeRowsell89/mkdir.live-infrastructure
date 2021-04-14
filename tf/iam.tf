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