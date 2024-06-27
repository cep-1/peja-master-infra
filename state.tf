terraform {
  backend "s3" {
    bucket = "team-peja-master-infra-eu"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}