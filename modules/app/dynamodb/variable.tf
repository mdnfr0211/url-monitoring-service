variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "partition_key" {
  description = "The attribute to use as the parition key. Must also be defined as an attribute"
  type        = string
}

variable "sort_key" {
  description = "The attribute to use as the sort key. Must also be defined as an attribute"
  type        = string
}

variable "index_key_attributes" {
  description = "The attribute of the Global Secondary Index"
  type        = list(any)
  default     = []
}

variable "billing_mode" {
  description = "Controls how you are billed for read/write throughput and how you manage capacity. The valid values are PROVISIONED or PAY_PER_REQUEST"
  type        = string
  default     = "PROVISIONED"
}

variable "min_read_capacity" {
  description = "The number of read units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
  type        = number
  default     = 1
}

variable "min_write_capacity" {
  description = "The number of write units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
  type        = number
  default     = 1
}

variable "max_read_capacity" {
  description = "The number of read units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
  type        = number
  default     = 10
}

variable "max_write_capacity" {
  description = "The number of write units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
  type        = number
  default     = 10
}

variable "index_scaling_policy" {
  description = "The Global Secondary Index Policy"
  type        = map(any)
  default     = {}
}

variable "autoscaling_enabled" {
  description = "Whether or not to enable autoscaling"
  type        = bool
  default     = true
}

variable "global_secondary_indexes" {
  description = "Describe a GSI for the table; subject to the normal limits on the number of GSIs, projected attributes, etc."
  type        = any
  default     = []
}

variable "local_secondary_indexes" {
  description = "Describe an LSI on the table; these can only be allocated at creation so you cannot change this definition after you have created the resource."
  type        = any
  default     = []
}

variable "partition_key_type" {
  description = "Type of Parition Key: N|S|B"
  type        = string
  default     = "S"
}

variable "sort_key_type" {
  description = "Type of Sort Key: N|S|B"
  type        = string
  default     = "S"
}

variable "ttl_enabled" {
  description = "Indicates whether ttl is enabled"
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "The name of the table attribute to store the TTL timestamp in"
  type        = string
  default     = ""
}
