output "web_acl_arn" {
  description = "ARN of the WAFv2 Web ACL."
  value       = aws_wafv2_web_acl.main.arn
}

output "web_acl_id" {
  description = "ID of the WAFv2 Web ACL."
  value       = aws_wafv2_web_acl.main.id
}

output "log_group_name" {
  description = "CloudWatch log group receiving WAF logs."
  value       = aws_cloudwatch_log_group.waf.name
}
