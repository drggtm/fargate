locals {
  name        = var.project_name
  name_prefix = substr(replace(var.project_name, "/[^a-zA-Z0-9-]/", ""), 0, 20)

  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  public_subnet_cidrs = [
    cidrsubnet(var.vpc_cidr, 8, 0),
    cidrsubnet(var.vpc_cidr, 8, 1),
  ]

  private_subnet_cidrs = [
    cidrsubnet(var.vpc_cidr, 8, 10),
    cidrsubnet(var.vpc_cidr, 8, 11),
  ]

  ecs_cluster_name       = "${local.name}-cluster"
  ecs_service_name       = "${local.name}-service"
  task_definition_family = "${local.name}-task"
  log_group_name         = "/ecs/${local.name}"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "./modules/vpc"

  name                 = local.name
  vpc_cidr             = var.vpc_cidr
  azs                  = local.azs
  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
  nat_gateway_mode     = var.nat_gateway_mode
}

module "security" {
  source = "./modules/security"

  name                 = local.name
  name_prefix          = local.name_prefix
  vpc_id               = module.vpc.vpc_id
  container_port       = var.container_port
  private_subnet_cidrs = module.vpc.private_subnet_cidrs
  vpc_cidr             = module.vpc.vpc_cidr
}

module "ecr" {
  source = "./modules/ecr"

  repository_name = "${local.name_prefix}-app"
}

module "secrets" {
  source = "./modules/secrets"

  secret_name        = "${local.name}/app"
  secret_description = "Application secret consumed by ECS tasks."
}

module "iam" {
  source = "./modules/iam"

  name_prefix        = local.name_prefix
  github_repo        = var.github_repo
  aws_region         = var.aws_region
  log_group_name     = local.log_group_name
  ecr_repository_arn = module.ecr.repository_arn
  secret_arn         = module.secrets.secret_arn
  ecs_cluster_name   = local.ecs_cluster_name
  ecs_service_name   = local.ecs_service_name
}

module "alb" {
  source = "./modules/alb"

  name_prefix           = local.name_prefix
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  container_port        = var.container_port
  health_check_path     = var.health_check_path
}

module "vpc_endpoints" {
  count  = var.enable_vpc_endpoints ? 1 : 0
  source = "./modules/vpc_endpoints"

  name_prefix             = local.name_prefix
  vpc_id                  = module.vpc.vpc_id
  vpc_cidr                = module.vpc.vpc_cidr
  private_subnet_ids      = module.vpc.private_subnet_ids
  private_route_table_ids = module.vpc.private_route_table_ids
  aws_region              = var.aws_region
}

module "ecs_service" {
  source = "./modules/ecs_service"

  name                     = local.name
  aws_region               = var.aws_region
  cpu                      = var.cpu
  memory                   = var.memory
  container_image          = var.container_image
  container_port           = var.container_port
  desired_count            = var.desired_count
  autoscaling_min_capacity = var.autoscaling_min_capacity
  autoscaling_max_capacity = var.autoscaling_max_capacity
  execution_role_arn       = module.iam.ecs_execution_role_arn
  task_role_arn            = module.iam.ecs_task_role_arn
  secret_arn               = module.secrets.secret_arn
  private_subnet_ids       = module.vpc.private_subnet_ids
  ecs_security_group_id    = module.security.ecs_security_group_id
  target_group_arn         = module.alb.target_group_arn
  log_retention_in_days    = var.log_retention_in_days

  depends_on = [module.alb]
}
