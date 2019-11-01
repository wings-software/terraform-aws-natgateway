variable "network_name" {}

variable "resource_tags" {
  type = "map"
}

variable "public_subnet_id" {}
variable "private_subnet_id" {}
variable "private_subnet_egress_cidr_block" {}

variable "private_subnet_route_table" {
  default = "XXXX"
}

variable "vpc_id" {
  default = "XXX"
}

variable "create_route_table" {
  default = false
}
