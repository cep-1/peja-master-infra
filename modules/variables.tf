variable "public_subnet_1" {
    description = "The AZ for public subnet 1"
    type = string
}

variable "public_subnet_2" {
    description = "The AZ for public subnet 2"
    type = string
}

variable "private_subnet_1" {
    description = "The AZ for private subnet 1"
    type = string
}

variable "private_subnet_2" {
    description = "The AZ for private subnet 2"
    type = string
}

variable "launch_template_ami_id" {
    description = "The ami id for the launch template"
    type = string
}

variable "launch_template_instance_type" {
    description = "Instance type for all EC2 instances"
    type = string
}

variable "asg_min_size" {
    description = "Minimum number of EC2 instances"
    type = number
}

variable "asg_desired_size" {
    description = "Desired number of EC2 instances"
    type = number
}

variable "asg_max_size" {
    description = "Maximum number of EC2 instances"
    type = number
}