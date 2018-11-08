resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name             = "ecs_autoscaling_group"
  max_size         = "${var.max_instance_size}"
  min_size         = "${var.min_instance_size}"
  desired_capacity = "${var.desired_capacity}"

  vpc_zone_identifier = ["${aws_subnet.relayPublicSN0.id}", "${aws_subnet.relayPublicSN1.id}", "${aws_subnet.relayPublicSN2.id}"]

  launch_configuration = "${aws_launch_configuration.relay_launch_configuration.name}"
  health_check_type    = "EC2"
}

resource "aws_launch_configuration" "relay_launch_configuration" {
  name                 = "relay_launch_configuration"
  image_id             = "${var.ami_id}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.relay_instance_profile.id}"

  root_block_device {
    volume_type           = "standard"
    volume_size           = 20
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups = ["${aws_security_group.relaySG.id}"]

  associate_public_ip_address = "true"
  key_name                    = "${var.key_pair}"

  user_data = <<-EOF
    #!/bin/bash
    echo ECS_CLUSTER=${var.ecs_cluster} >> /etc/ecs/ecs.config
  EOF
}
