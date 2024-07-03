provider "aws" {
    alias = "us_east_1"
    region = "us-east-1"
}

provider "aws" {
    alias = "eu_central_1"
    region = "eu-central-1"
}

module "master-infra-eu" {
    source = "./modules"
    providers = {
        aws = aws.eu_central_1
    }

    private_subnet_1 = "eu-central-1a"
    private_subnet_2 = "eu-central-1b"
    private_subnet_3 = "eu-central-1c"
    public_subnet_1 = "eu-central-1a"
    public_subnet_2 = "eu-central-1b"
    launch_template_ami_id = "ami-0a3041ff14fb6e2be"
    launch_template_instance_type = "t2.micro"
    asg_min_size = 2
    asg_desired_size = 2
    asg_max_size = 2

}
module "master-infra-us" {
    source = "./modules"
    providers = {
        aws = aws.us_east_1
    }
    private_subnet_1 = "us-east-1a"
    private_subnet_2 = "us-east-1b"
    private_subnet_3 = "us-east-1c"
    public_subnet_1 = "us-east-1a"
    public_subnet_2 = "us-east-1b"
    launch_template_ami_id = "ami-0195204d5dce06d99"
    launch_template_instance_type = "t2.micro"
    asg_min_size = 1
    asg_desired_size = 1
    asg_max_size = 2


}
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}
variable "cloudflare_api_token" {}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}