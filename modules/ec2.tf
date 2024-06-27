# Launch Template with User Data and EBS
resource "aws_launch_template" "app" {
  name_prefix   = "app-launch-template-"
  image_id      = var.launch_template_ami_id
  instance_type = var.launch_template_instance_type

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo su
    yum update -y
    yum install -y httpd.x86_64
    systemctl start httpd.service
    systemctl enable httpd.service
    echo "This is $(hostname)" > /var/www/html/index.html
  EOF
  )

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.allow_web.id]
  }
}

# AutoScaling Group
resource "aws_autoscaling_group" "app" {
  min_size            = var.asg_min_size
  desired_capacity    = var.asg_desired_size
  max_size            = var.asg_max_size
  vpc_zone_identifier = [aws_subnet.private1.id, aws_subnet.private2.id]
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  # Use ALB for health checks
  health_check_type         = "ELB"
  health_check_grace_period = 50

  target_group_arns = [aws_lb_target_group.app_tg.arn]

}