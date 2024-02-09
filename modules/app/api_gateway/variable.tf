variable "apigw_name" {
  type        = string
  description = "Name of the API Gateway"
}

variable "lambda_arn" {
  type        = string
  description = "ARN of Lambda Function"
}

variable "lambda_permission" {
  type        = map(any)
  description = "Map Contains the Permission to be Added to the Lambda Function"
}
