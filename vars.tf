variable "ecs_cluster" {
  description = "ECS cluster name"
}

variable "key_pair" {
  description = "ECS key pair name"
}

variable "region" {
  description = "AWS region"
}

########################### Autoscale Config ################################

variable "max_instance_size" {
  description = "Maximum number of instances in the cluster"
}

variable "min_instance_size" {
  description = "Minimum number of instances in the cluster"
}

variable "desired_capacity" {
  description = "Desired number of instances in the cluster"
}

variable "ami_id" {
  description = "Desired number of instances in the cluster"
}

variable "instance_type" {
  description = "Desired number of instances in the cluster"
}
