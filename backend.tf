terraform {
  backend "s3" {
    bucket       = "project03-tfstate-804837307353"
    key          = "project03/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
