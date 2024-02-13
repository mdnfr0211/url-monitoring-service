# URL Monitoring Service

This URL monitoring service is designed to efficiently check the status of specified endpoints, store the results in DynamoDB, and provide a user-friendly API for querying the latest status. The service is divided into two primary flows, leveraging various AWS services to achieve seamless functionality.

![url-monitoring](https://github.com/mdnfr0211/url-monitoring-system/assets/55761300/2141dd70-f102-46c9-82b5-77ed9122bfe5)

## Prerequisites

- Terraform: The infrastructure is managed using Terraform. Ensure it is installed on your local machine
- AWS Accounts: You need AWS account(s) with IAM user(s) possessing the necessary permissions. The deployment instructions are flexible and support both single and multiple AWS accounts. Choose the pattern that aligns with your testing preferences

## Architecture Overview
### Automated Monitoring

In this flow, an EventBridge scheduler triggers a Lambda function every 5 minutes. The Lambda function downloads a CSV file from an S3 bucket, containing the list of endpoints to monitor. It then proceeds to check the status of each URL and stores the results in DynamoDB.

### User Query

Users can query the status of a website by hitting an endpoint backed by API Gateway. The API Gateway is connected to an AWS Lambda function, which queries DynamoDB and returns the response.

## Components Involved

- API Gateway: Provides a secure and scalable API endpoint for users to interact with the service.
- Lambda: Executed in both flows, this serverless function handles endpoint checks and user queries. It is tightly integrated with API Gateway and DynamoDB.
- DynamoDB: A NoSQL database used to store website status information. The Lambda functions read and write data to DynamoDB.
- EventBridge Scheduler: Orchestrates the automated monitoring flow by triggering the Lambda function at regular intervals.
- S3: Asset S3 bucket stores a CSV file with the list of endpoints. The Lambda function downloads this file for URL monitoring.

## Result

### Data from DynamoDB
<img width="693" alt="Screenshot 2024-02-13 174248" src="https://github.com/mdnfr0211/url-monitoring-service/assets/55761300/0a42ad4c-4ccd-4246-b226-f0b8dd111be5">

###  API Gateway Endpoint Status
<img width="693" alt="image" src="https://github.com/mdnfr0211/url-monitoring-service/assets/55761300/14026236-d600-41ff-a394-ed07aae74650">
