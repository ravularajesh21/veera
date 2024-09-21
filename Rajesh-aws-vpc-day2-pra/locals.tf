locals {
    name = "${var.project_name}-${var.environment}"
}

locals {
    az_names = slice(data.aws_availability_zones.azs.name0,2)
}