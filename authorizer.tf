resource "aws_api_gateway_authorizer" "cognito" {
  name                           = "cognito_authorizer"
  rest_api_id                    = aws_api_gateway_rest_api.pokemon_api.id
  type                           = "COGNITO_USER_POOLS"
  provider_arns                  = [aws_cognito_user_pool.pokemon.arn]
}