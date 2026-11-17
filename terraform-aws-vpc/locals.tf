locals {
  common_name = "${var.project}-${var.environment}" #roboshop-dev
  common_tags = {
    project = var.project
    environment = var.environment
    terraform = true
    name = local.common_name
  }
availability_zone=slice(data.aws_availability_zones.available.names,0,2)

}