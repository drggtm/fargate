output "sns_topic_arn" {
  description = "ARN of the SNS topic receiving alarm notifications."
  value       = aws_sns_topic.alarms.arn
}

output "alarm_names" {
  description = "Names of the alarms created by this module."
  value = [
    aws_cloudwatch_metric_alarm.alb_5xx.alarm_name,
    aws_cloudwatch_metric_alarm.target_5xx.alarm_name,
    aws_cloudwatch_metric_alarm.unhealthy_hosts.alarm_name,
    aws_cloudwatch_metric_alarm.ecs_task_crash_loop.alarm_name,
  ]
}
