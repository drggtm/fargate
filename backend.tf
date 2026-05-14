terraform {
  backend "s3" {
    key          = "ecs/terraform.tfstate"
    use_lockfile = true
  }
}
