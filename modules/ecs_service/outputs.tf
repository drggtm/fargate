output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "service_name" {
  value = aws_ecs_service.main.name
}

output "service_id" {
  value = aws_ecs_service.main.id
}

output "task_definition_family" {
  value = aws_ecs_task_definition.main.family
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.main.name
}

output "log_group_arn" {
  value = aws_cloudwatch_log_group.main.arn
}
