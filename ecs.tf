data "aws_availability_zones" "available" {}

resource "aws_ecs_cluster" "relayCluster" {
  name = "${var.ecs_cluster}"
}

data "aws_ecs_task_definition" "backend" {
  task_definition = "${aws_ecs_task_definition.backend.family}"
}

resource "aws_ecs_task_definition" "backend" {
  family = "backend"

  container_definitions = <<DEFINITION
[
  {
    "name": "backend",
    "image": "kabae/relay42-date",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 3333,
        "hostPort": 3333
      }
    ],
    "memory": 500,
    "cpu": 10
  }
]
DEFINITION
}

data "aws_ecs_task_definition" "frontend" {
  task_definition = "${aws_ecs_task_definition.frontend.family}"
}

resource "aws_ecs_task_definition" "frontend" {
  family = "frontend"

  container_definitions = <<DEFINITION
[
  {
    "name": "frontend",
    "image": "kabae/relay42-test",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ],
    "memory": 500,
    "cpu": 10
  }
]
DEFINITION
}

resource "aws_ecs_service" "relay42-service" {
  depends_on = ["aws_ecs_cluster.relayCluster", "aws_alb.relayALB"]

  provisioner "local-exec" {
    command = "sleep 10"
  }

  name            = "relay42-service"
  iam_role        = "${aws_iam_role.relay_service_role.name}"
  cluster         = "${aws_ecs_cluster.relayCluster.id}"
  task_definition = "${aws_ecs_task_definition.frontend.family}:${max("${aws_ecs_task_definition.frontend.revision}", "${data.aws_ecs_task_definition.frontend.revision}")}"

  # desired_count   = 3
  desired_count = "${length(data.aws_availability_zones.available.names)}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.relayALB_TG.arn}"
    container_port   = 8080
    container_name   = "frontend"
  }
}

resource "aws_ecs_service" "relay42-backend-service" {
  depends_on = ["aws_ecs_cluster.relayCluster", "aws_alb.relayALB"]

  provisioner "local-exec" {
    command = "sleep 10"
  }

  name            = "relay42-backend-service"
  cluster         = "${aws_ecs_cluster.relayCluster.id}"
  task_definition = "${aws_ecs_task_definition.backend.family}:${max("${aws_ecs_task_definition.backend.revision}", "${data.aws_ecs_task_definition.backend.revision}")}"

  # desired_count   = 3
  desired_count = "${length(data.aws_availability_zones.available.names)}"
}
