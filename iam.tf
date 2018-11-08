#### ec2 ecs instance 

data "aws_iam_policy_document" "relay_policy_doc" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "relay_instance_role" {
  name               = "relay_instance_role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.relay_policy_doc.json}"
}

resource "aws_iam_role_policy_attachment" "relay_instance_role_attachment" {
  role       = "${aws_iam_role.relay_instance_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "relay_instance_profile" {
  name = "relay_instance_profile"
  path = "/"
  role = "${aws_iam_role.relay_instance_role.id}"

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

#### ecs service

data "aws_iam_policy_document" "relay_service_policy_doc" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ecs.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "relay_service_role" {
  name               = "relay_service_role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.relay_service_policy_doc.json}"
}

resource "aws_iam_role_policy_attachment" "relay_service_role_attachment" {
  role       = "${aws_iam_role.relay_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}
