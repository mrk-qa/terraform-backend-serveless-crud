# -*- coding: utf-8 -*-

import boto3
import csv

def load_data_from_csv(table_name, file_path):
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
    table = dynamodb.Table(table_name)
    with open(file_path, 'r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            item = {
                'index': int(row['index']),
                'name': row['name']
            }
            table.put_item(Item=item)
            print("Added item: {}".format(item))

load_data_from_csv("PokemonTable", "data/pokemon.csv")
