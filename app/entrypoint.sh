#!/bin/bash

export AWS_AZ=$(curl -s -q http://169.254.169.254/latest/meta-data/placement/availability-zone)
bash -x /opt/project/mvnw spring-boot:run