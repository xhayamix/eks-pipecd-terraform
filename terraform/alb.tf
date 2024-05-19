# ALBの作成
resource "aws_lb" "my_alb" {
  name               = var.alb_name
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_c.id]
  security_groups    = [aws_security_group.alb_security_group.id]

  enable_deletion_protection = false
}

# ALBターゲットグループの作成
resource "aws_lb_target_group" "my_tg" {
  name             = var.target_group_name
  port             = 30020
  protocol         = "HTTP"
  vpc_id           = aws_vpc.main.id
  target_type      = "instance"

  health_check {
    interval            = 30
    path                = "/health"  # ここを変更
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 5
    matcher             = "200"
  }
}

# ALBリスナーの作成
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}

# ALB Listener Rule
resource "aws_lb_listener_rule" "lb_listener_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}


// eksクラスタ生成後に使う
resource "aws_autoscaling_attachment" "autoscaling_attachment" {
  autoscaling_group_name = var.autoscaling_group_name
  lb_target_group_arn    = aws_lb_target_group.my_tg.arn
}
