resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com",
      },
      Action = ["sts:AssumeRole"],
    }]
  })
}

resource "aws_iam_policy" "dynamodb_access" {
  name        = "dynamodb_access"
  description = "IAM policy for accessing DynamoDB"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ],
        Resource = "arn:aws:dynamodb:*:*:table/PokemonTable" # Substitua 'PokemonTable' pelo nome da sua tabela DynamoDB
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "dynamodb_access_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}

resource "aws_iam_role" "lambda_token_role" {
  name = "lambda_token_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
        Action = ["sts:AssumeRole"],
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_cognito_policy" {
  name        = "lambda-cognito-policy"
  description = "Policy for Lambda to interact with Cognito"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "cognito-idp:AdminInitiateAuth",
          "cognito-idp:AdminRespondToAuthChallenge",
          "cognito-idp:InitiateAuth",
          "cognito-idp:RespondToAuthChallenge",
          "cognito-idp:DescribeUserPool"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "token_access_attachment" {
  role       = aws_iam_role.lambda_token_role.name
  policy_arn = aws_iam_policy.lambda_cognito_policy.arn
}