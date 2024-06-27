provider "aws" {
    region = "us-east-1"
}

module "master-infra" {
    source = "../modules"

    private_subnet_1 = "us-east-1a"
    private_subnet_2 = "us-east-1b"
    public_subnet_1 = "us-east-1a"
    public_subnet_2 = "us-east-1b"
    launch_template_ami_id = "ami-0195204d5dce06d99"
    launch_template_instance_type = "t2.micro"
    asg_min_size = 1
    asg_desired_size = 1
    asg_max_size = 2

}