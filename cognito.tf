resource "aws_cognito_user_pool" "pokemon" {
  name                     = "pokemon_pool"
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_client" "developer" {
  name                                 = "client_cognito"
  callback_urls                        = ["https://pokemon-crud/callback"]
  logout_urls                          = ["https://pokemon-crud/signout"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "aws.cognito.signin.user.admin", "profile"]
  supported_identity_providers         = ["COGNITO"]

  user_pool_id        = aws_cognito_user_pool.pokemon.id
  generate_secret     = true
  explicit_auth_flows = ["ALLOW_CUSTOM_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
}

resource "aws_cognito_user" "marco" {
  username     = "marco.ant.seg@gmail.com"
  user_pool_id = aws_cognito_user_pool.pokemon.id
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "pokemon-crud"
  user_pool_id = aws_cognito_user_pool.pokemon.id
}

resource "aws_cognito_resource_server" "auth" {
  identifier = "cognito"
  name       = "cognito"

  scope {
    scope_name        = "auth"
    scope_description = "Authorization Requests"
  }

  user_pool_id = aws_cognito_user_pool.pokemon.id
}