variables "vpc_cidr" {
    cidr_block = "10.0.0.1/16"
}

variables "enable_dns_hostnames" {
    type = bool
    default = true
}

variables "vpc_tags" {
    default = {}
}
variables "project_name" {
    default = {}
}
variables "environment" {
    default = {}
}

variables "igw_tags" {
    default = {}
}

variables "public_subnets_cidr" {
    type = list
    validation {
        condition = length(var.public_subnets_cidr) == 2
        error_message = "Please give 2 public_subnets_cidr"
    }
}

variables "public_subnets_tags" {
    default = {}
}

variables "private_subnets_cidr" {
    type = list
    validation {
        condition = length(var.private_subnets_cidr) == 2
        error_message = "Please give 2 private_subnets_cidr"
    }
}

variable "private_subnets_cidr" {
    default = {}
}

variable "database_subnets_cidr" {
    type = list
    validation {
        condition = length(var.database_subnets_cidr) == 2
        error_message = "Please give 2 database_subnets_cidr"
    }
}

variables "database_subnets_tags" {
    default = {}
}

variables "nat_gateway_tags" {
    default = {}
}
variables "private_route_table_tags" {
    default = {}
}

variables "public_route_table_tags" {
    default = {}
}

variables "database_route_table_tags" {
    default = {}
}