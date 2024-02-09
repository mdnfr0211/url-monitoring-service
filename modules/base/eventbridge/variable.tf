variable "schedule_name" {
  description = "Name of the Eventbridge Scheduler Name"
  type        = string
}

variable "lambda_arns" {
  description = "List of Lambda as Targets"
  type        = list(any)
}
