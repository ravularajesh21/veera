locals {
    name = "${var.project_name}-${var.environment}"
    az_names = data.slice(aws_availability_zones.azs.name,0,2)      # it will get 1,2 aws_availability_zones 
}