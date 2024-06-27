terraform {
  backend "s3" {
    bucket = "team-peja-master-infra-us"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}