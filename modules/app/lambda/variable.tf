variable "lambda_api_functions" {
  type        = map(any)
  description = "Name of Lambda Function"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids when Lambda Function should run in the VPC"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC in which Security Group needs to be created"
}

variable "cw_logs_retention" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  type        = number
  default     = 14
}

variable "lambda_layer_name" {
  description = "Name of the Layer to be attached to the Lambda"
  type        = string
}

variable "local_existing_package" {
  description = "Path of Zip of Lambda Layer"
  type        = string
}
