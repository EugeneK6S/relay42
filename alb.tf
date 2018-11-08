resource "aws_alb" "relayALB" {
  name            = "relayALB"
  security_groups = ["${aws_security_group.external-relaySG.id}"]
  subnets         = ["${aws_subnet.relayPublicSN0.id}", "${aws_subnet.relayPublicSN1.id}", "${aws_subnet.relayPublicSN2.id}"]

  tags {
    Name = "ecs-load-balancer"
  }
}

resource "aws_alb_listener" "relayALB_listener" {
  load_balancer_arn = "${aws_alb.relayALB.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.relayALB_TG.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "relayALB_TG" {
  provisioner "local-exec" {
    command = "sleep 10"
  }

  name     = "relayALBTG"
  port     = "8080"
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.relayVPC.id}"

  health_check {
    healthy_threshold   = "3"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/hello"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

  tags {
    Name = "ecs-target-group"
  }
}

resource "aws_alb_listener_rule" "listener_rule" {
  depends_on   = ["aws_alb_target_group.relayALB_TG"]
  listener_arn = "${aws_alb_listener.relayALB_listener.arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.relayALB_TG.id}"
  }

  condition {
    field  = "path-pattern"
    values = ["/"]
  }
}

resource "aws_autoscaling_attachment" "svc_asg_external2" {
  depends_on             = ["aws_alb_target_group.relayALB_TG", "aws_autoscaling_group.ecs_autoscaling_group"]
  alb_target_group_arn   = "${aws_alb_target_group.relayALB_TG.arn}"
  autoscaling_group_name = "${aws_autoscaling_group.ecs_autoscaling_group.id}"
}
