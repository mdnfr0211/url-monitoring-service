output "table_name" {
  value       = module.dynamodb_table.dynamodb_table_id
  description = "Name/ID of the DynamoDB Table"
}
