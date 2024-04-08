resource "aws_lambda_function" "pokemon_lambda" {
  function_name = "crud"
  handler       = "crud.lambda_handler"
  runtime       = "python3.9"
  filename      = "lambda/crud.zip"
  role          = aws_iam_role.lambda_execution_role.arn

  source_code_hash = filebase64sha256("lambda/crud.zip")
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.pokemon_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}