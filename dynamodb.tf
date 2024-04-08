resource "aws_dynamodb_table" "pokemon_table" {
  name         = "PokemonTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "index"
  range_key    = "name"

  attribute {
    name = "index"
    type = "N"
  }

  attribute {
    name = "name"
    type = "S"
  }

  tags = {
    Name = "PokemonDynamoDBTable"
  }
}

resource "null_resource" "import_data" {
  depends_on = [aws_dynamodb_table.pokemon_table]

  provisioner "local-exec" {
    command     = "python data/import.py"
    working_dir = path.module
  }
}