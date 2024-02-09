module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "3.3.0"

  name                                  = var.table_name
  hash_key                              = var.partition_key
  range_key                             = var.sort_key
  billing_mode                          = var.billing_mode
  read_capacity                         = var.billing_mode == "PROVISIONED" ? var.min_read_capacity : null
  write_capacity                        = var.billing_mode == "PROVISIONED" ? var.min_write_capacity : null
  autoscaling_enabled                   = var.autoscaling_enabled
  ignore_changes_global_secondary_index = true

  autoscaling_read = var.billing_mode == "PROVISIONED" && var.autoscaling_enabled ? local.read_autoscaling_policy : {}

  autoscaling_write = var.billing_mode == "PROVISIONED" && var.autoscaling_enabled ? local.write_autoscaling_policy : {}

  autoscaling_indexes = var.billing_mode == "PROVISIONED" && var.autoscaling_enabled && length(var.global_secondary_indexes) > 0 ? var.index_scaling_policy : {}

  global_secondary_indexes = length(var.global_secondary_indexes) > 0 ? var.global_secondary_indexes : []

  local_secondary_indexes = var.local_secondary_indexes

  ttl_enabled        = var.ttl_enabled
  ttl_attribute_name = var.ttl_attribute_name

  attributes = concat([
    {
      name = var.partition_key
      type = var.partition_key_type
    }
  ], local.sort_key_attribute, local.index_key_attributes)
}
