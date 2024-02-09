locals {
  read_autoscaling_policy = {
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
    target_value       = 70
    max_capacity       = var.max_read_capacity
  }
  write_autoscaling_policy = {
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
    target_value       = 70
    max_capacity       = var.max_write_capacity
  }
  sort_key_attribute = length(var.sort_key) > 0 ? [{
    name = var.sort_key
    type = var.sort_key_type
  }] : []
  index_key_attributes = var.index_key_attributes
}
