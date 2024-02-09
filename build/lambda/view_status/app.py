import os
import boto3
import json
import csv
import concurrent.futures

s3_client = boto3.client("s3")
dynamodb_client = boto3.client("dynamodb")

table_name = os.getenv("TABLE_NAME")
bucket_name = os.getenv("ASSET_BUCKET_NAME")
object_key = os.getenv("OBJECT_KEY")

def download_csv_from_s3():
    response = s3_client.get_object(Bucket=bucket_name, Key=object_key)
    content = response["Body"].read().decode("utf-8")
    return content


def extract_urls_from_csv(file_content):
    urls = []

    csv_lines = file_content.strip().splitlines()
    csv_reader = csv.reader(csv_lines, delimiter=',')

    next(csv_reader, None)

    for row in csv_reader:
        if len(row) >= 2:
            urls.append(row[1])

    return urls

def query_dynamodb(url_values):
    items = []

    def get_items(url_value):
        response = dynamodb_client.query(
            TableName=table_name,
            KeyConditionExpression='urls = :urls',
            ExpressionAttributeValues={
                ':urls': {'S': url_value}
            },
            Limit=1,
            ScanIndexForward=False
        )

        items.append({
                "urls": response["Items"][0]["urls"].get("S"),
                "timestamp": response["Items"][0]["timestamp"].get("S"),
                "status": response["Items"][0]["status"].get("N")
            })

    with concurrent.futures.ThreadPoolExecutor() as executor:
        futures = executor.map(get_items, url_values)

    return items


def lambda_handler(event, context):
    path = event["rawPath"]

    csv_content = download_csv_from_s3()
    urls = extract_urls_from_csv(file_content=csv_content)

    url_status = query_dynamodb(urls)

    if path == "/":
        return {"statusCode": 200, "body": json.dumps({"ping": "pong"})}
    elif path == "/status":
        return {"statusCode": 200, "body": json.dumps(url_status)}
    else:
        return {"statusCode": 404, "body": "Not Found"}
