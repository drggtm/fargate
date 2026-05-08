module "s3_backend" {
  source      = "../modules/s3_backend"
  aws_region  = var.aws_region
  aws_profile = var.aws_profile
}

output "backend" {
  value = module.s3_backend
}
