provider "aws" {
    region = "eu-central-1"
}

module "master-infra" {
    source = "../modules"

    private_subnet_1 = "eu-central-1a"
    private_subnet_2 = "eu-central-1b"
    public_subnet_1 = "eu-central-1a"
    public_subnet_2 = "eu-central-1b"
    launch_template_ami_id = "ami-0a3041ff14fb6e2be"
    launch_template_instance_type = "t2.micro"
    asg_min_size = 2
    asg_desired_size = 2
    asg_max_size = 2

}