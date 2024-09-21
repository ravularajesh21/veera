variable "vpc_cidr" {
    type = list
    cidr_block = ["10.0.0.0/16"]

}
variable "vpc_tags" {
    default = {}
}
variable "project_name" {
    default = "roboshop"
}
variable "environment" {
    default = "dev"
}
variable "enable_dns_hostnames" {
    default = {}
}
