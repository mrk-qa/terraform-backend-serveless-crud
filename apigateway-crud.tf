resource "aws_api_gateway_rest_api" "pokemon_api" {
  name = "crud_pokemon"
}

resource "aws_api_gateway_resource" "pokemon_resource" {
  rest_api_id = aws_api_gateway_rest_api.pokemon_api.id
  parent_id   = aws_api_gateway_rest_api.pokemon_api.root_resource_id
  path_part   = "pokemon"
}

resource "aws_api_gateway_method" "get_pokemon_method" {
  rest_api_id   = aws_api_gateway_rest_api.pokemon_api.id
  resource_id   = aws_api_gateway_resource.pokemon_resource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_method" "post_pokemon_method" {
  rest_api_id   = aws_api_gateway_rest_api.pokemon_api.id
  resource_id   = aws_api_gateway_resource.pokemon_resource.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_method" "put_pokemon_method" {
  rest_api_id   = aws_api_gateway_rest_api.pokemon_api.id
  resource_id   = aws_api_gateway_resource.pokemon_resource.id
  http_method   = "PUT"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_method" "delete_pokemon_method" {
  rest_api_id   = aws_api_gateway_rest_api.pokemon_api.id
  resource_id   = aws_api_gateway_resource.pokemon_resource.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "api_integration_get" {
  rest_api_id = aws_api_gateway_rest_api.pokemon_api.id
  resource_id = aws_api_gateway_resource.pokemon_resource.id
  http_method = aws_api_gateway_method.get_pokemon_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.pokemon_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "api_integration_post" {
  rest_api_id = aws_api_gateway_rest_api.pokemon_api.id
  resource_id = aws_api_gateway_resource.pokemon_resource.id
  http_method = aws_api_gateway_method.post_pokemon_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.pokemon_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "api_integration_put" {
  rest_api_id = aws_api_gateway_rest_api.pokemon_api.id
  resource_id = aws_api_gateway_resource.pokemon_resource.id
  http_method = aws_api_gateway_method.put_pokemon_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.pokemon_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "api_integration_delete" {
  rest_api_id = aws_api_gateway_rest_api.pokemon_api.id
  resource_id = aws_api_gateway_resource.pokemon_resource.id
  http_method = aws_api_gateway_method.delete_pokemon_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.pokemon_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_method.get_pokemon_method,
    aws_api_gateway_method.post_pokemon_method,
    aws_api_gateway_method.put_pokemon_method,
    aws_api_gateway_method.delete_pokemon_method,
    aws_api_gateway_integration.api_integration_get,
    aws_api_gateway_integration.api_integration_post,
    aws_api_gateway_integration.api_integration_put,
    aws_api_gateway_integration.api_integration_delete,
    aws_api_gateway_authorizer.cognito
  ]

  rest_api_id = aws_api_gateway_rest_api.pokemon_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.pokemon_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.pokemon_api.id
  stage_name    = "v1"
}