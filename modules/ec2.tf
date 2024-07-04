# Launch Template with User Data and EBS
resource "aws_launch_template" "app" {
  name_prefix   = "app-launch-template-"
  image_id      = var.launch_template_ami_id
  instance_type = var.launch_template_instance_type

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo su
    yum update -y
    yum install docker -y
    service docker start
    usermod -a -G docker ec2-user
    dnf -y install libxcrypt-compat
    dnf -y install libnsl
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    dnf -y install git
    git clone https://github.com/cep-1/peja-master-infra-app-deploy.git
    cd peja-master-infra-app-deploy/
    export VOTE_TAG=$(jq -r '.vote' "version.json")
    export WORKER_TAG=$(jq -r '.worker' "version.json")
    export RESULT_TAG=$(jq -r '.result' "version.json")
    export AWS_REGION=eu-central-1
    
    DB_CRED_STRING=$(aws secretsmanager get-secret-value --secret-id arn:aws:secretsmanager:eu-central-1:211125460791:secret:DB_CRED-7uVs1x | jq -r ".SecretString")
    export DB_USER=$(echo $DB_CRED_STRING | jq -r ".DB_USER")
    export DB_PASSWORD=$(echo $DB_CRED_STRING | jq -r ".DB_PASSWORD")

    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin 211125460791.dkr.ecr.eu-central-1.amazonaws.com

    docker-compose up -d

    echo "Waiting for Nginx Proxy Manager to be ready..."
    sleep 60

    create_proxy_host() {
      local DOMAIN=$1
      local FORWARD_HOST=$2
      local FORWARD_PORT=$3
      local EMAIL=$4
      local ACCESS_TOKEN=$5

      curl -X POST "http://localhost:81/api/nginx/proxy-hosts" \
        -H "Authorization: Bearer $ACCESS_TOKEN" \
        -H "Content-Type: application/json" \
        -d '{
          "domain_names": ["'"$DOMAIN"'"],
          "forward_scheme": "http",
          "forward_host": "'"$FORWARD_HOST"'",
          "forward_port": '"$FORWARD_PORT"',
          "ssl_forced": true,
          "meta": {
            "letsencrypt_email": "'"$EMAIL"'",
            "letsencrypt_agree": true
          },
          "advanced_config": "",
          "caching_enabled": false,
          "block_exploits": false,
          "http2_support": false
      }'
    }

  NGINX_SECRET_STRING=$(aws secretsmanager get-secret-value --secret-id arn:aws:secretsmanager:eu-central-1:211125460791:secret:nginxCred-GMh2qa | jq -r ".SecretString")
  ADMIN_EMAIL=$(echo $NGINX_SECRET_STRING | jq -r ".nginxEmail")
  ADMIN_PASSWORD=$(echo $NGINX_SECRET_STRING | jq -r ".nginxPassword")

  ACCESS_TOKEN=$(curl -s -X POST "http://localhost:81/api/tokens" \
  -H "Content-Type: application/json" \
  -d '{
    "identity": "'"$ADMIN_EMAIL"'",
    "secret": "'"$ADMIN_PASSWORD"'"
  }' | jq -r '.token')

  create_proxy_host "vote.peja.awskosova.com" "vote" 80 $ADMIN_EMAIL $ACCESS_TOKEN
  create_proxy_host "result.peja.awskosova.com" "result" 80 $ADMIN_EMAIL $ACCESS_TOKEN

  EOF
  )

  iam_instance_profile {
    arn = "arn:aws:iam::211125460791:instance-profile/FullImageAccess"
  }

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
  vpc_zone_identifier = [aws_subnet.private1.id, aws_subnet.private2.id, aws_subnet.private3.id]
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  # Use NLB for health checks
  health_check_type         = "ELB"
  health_check_grace_period = 50

  target_group_arns = [aws_lb_target_group.app_tg.arn]

}