output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer."
  value       = module.alb.dns_name
}

output "alb_url" {
  description = "HTTP endpoint for the deployed service."
  value       = "http://${module.alb.dns_name}"
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  value       = module.ecs_service.cluster_name
}

output "ecs_service_name" {
  description = "Name of the ECS service."
  value       = module.ecs_service.service_name
}

output "ecr_repository_url" {
  description = "ECR repository URL for CI/CD image pushes."
  value       = module.ecr.repository_url
}

output "ecr_repository_name" {
  description = "ECR repository name for CI/CD image pushes."
  value       = module.ecr.repository_name
}

output "app_secret_arn" {
  description = "ARN of the application secret stored in Secrets Manager."
  value       = module.secrets.secret_arn
}

output "nat_gateway_mode" {
  description = "NAT gateway strategy selected for this deployment."
  value       = var.nat_gateway_mode
}

output "github_actions_deploy_role_arn" {
  description = "OIDC role ARN for GitHub Actions image build and ECS deployment."
  value       = module.iam.github_actions_deploy_role_arn
}

output "task_definition_family" {
  description = "ECS task definition family used by the deployment workflow."
  value       = module.ecs_service.task_definition_family
}

output "public_subnet_ids" {
  description = "Public subnet IDs used by the ALB."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs used by the ECS tasks."
  value       = module.vpc.private_subnet_ids
}

output "alarms_sns_topic_arn" {
  description = "SNS topic that receives CloudWatch alarm notifications, if alarms are enabled."
  value       = try(module.alarms[0].sns_topic_arn, null)
}
