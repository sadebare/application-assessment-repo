resource "aws_lb" "cloudhight_load_balancer" {
  name               = "cloudhight-app-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.public_subnet_2.id]
  security_groups = [aws_security_group.alb_sg.id]
  enable_deletion_protection = false

  tags = {
    Name = "CloudhightAppLoadBalancer"
  }
}

resource "aws_lb_target_group" "docker_target_group" {
  name     = "docker-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    port                = 8080
    protocol            = "HTTP"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "docker_listener" {
  load_balancer_arn = aws_lb.cloudhight_load_balancer.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.docker_target_group.arn
  }
}
