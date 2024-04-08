import json
import boto3
from decimal import Decimal

class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            if obj % 1 == 0:
                return int(obj)
            else:
                return float(obj)
        return json.JSONEncoder.default(self, obj)

def lambda_handler(event, context):
    http_method = event['httpMethod']
    
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('PokemonTable')

    if http_method == 'GET':
        response = table.scan()
        items = response['Items']
        return {
            'statusCode': 200,
            'body': json.dumps(items, cls=DecimalEncoder)
        }
    elif http_method == 'POST':
        new_item = json.loads(event['body'])
        table.put_item(Item=new_item)
        return {
            'statusCode': 201,
            'body': json.dumps({'message': 'Pokemon CRIADO com sucesso!'})
        }
    elif http_method == 'PUT':
        updated_item = json.loads(event['body'])
        table.put_item(Item=updated_item)
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Pokemon ALTERADO com sucesso!'})
        }
    elif http_method == 'DELETE':
        item_to_delete = json.loads(event['body'])
        item_to_delete = {key: int(value) if key == 'index' else value for key, value in item_to_delete.items()}
        table.delete_item(Key=item_to_delete)
        return {
            'statusCode': 204,
            'body': json.dumps({'message': 'Pokemon DELETADO com sucesso!'})
        }
    else:
        return {
            'statusCode': 405,
            'body': json.dumps({'message': 'Method not allowed'})
        }
