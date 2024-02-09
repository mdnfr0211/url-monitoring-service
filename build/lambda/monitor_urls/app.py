import os
import boto3
import requests
import csv
import concurrent.futures
from datetime import datetime

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


def check_url_status(url):
    status_results = []
    current_timestamp = str(datetime.now())

    def check_single_url(url):
        try:
            response = requests.get(url, verify=False, timeout=5)
            status_results.append({"url": url, "status": response.status_code, "timestamp": current_timestamp})
        except requests.exceptions.Timeout:
            status_results.append({"url": url, "status": 504, "timestamp": current_timestamp})
        except:
            status_results.append({"url": url, "status": 500, "timestamp": current_timestamp})

    with concurrent.futures.ThreadPoolExecutor() as executor:
        futures = executor.map(check_single_url, url)

    return status_results


def batch_put_items_to_dynamodb(items):
    put_requests = [
        {
            "PutRequest": {
                "Item": {
                    "timestamp": {"S": item["timestamp"]},
                    "urls": {"S": item["url"]},
                    "status": {'N': str(item['status'])},
                }
            }
        }
        for item in items
    ]

    response = dynamodb_client.batch_write_item(RequestItems={table_name: put_requests})

    return response


def lambda_handler(event, context):
    csv_content = download_csv_from_s3()
    urls = extract_urls_from_csv(file_content=csv_content)
    status_results = check_url_status(urls)

    batch_put_items_to_dynamodb(status_results)
