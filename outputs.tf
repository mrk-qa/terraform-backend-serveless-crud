output "api_gateway_url" {
  value = "${aws_api_gateway_stage.stage.invoke_url}/${aws_api_gateway_resource.pokemon_resource.path_part}"
}