terraform {
  backend "s3" {
    key          = "blys-2/terraform.tfstate"
    use_lockfile = true
  }
}
