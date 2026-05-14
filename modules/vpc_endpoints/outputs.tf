output "interface_endpoint_ids" {
  description = "Map of interface VPC endpoint IDs keyed by service."
  value       = { for k, ep in aws_vpc_endpoint.interface : k => ep.id }
}

output "s3_endpoint_id" {
  description = "Gateway VPC endpoint ID for S3."
  value       = aws_vpc_endpoint.s3.id
}

output "security_group_id" {
  description = "Security group attached to the interface endpoints."
  value       = aws_security_group.endpoints.id
}
