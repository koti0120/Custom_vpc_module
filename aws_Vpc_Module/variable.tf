variable "project_name" {
  type = string
}
variable "environment" {
  type = string
}
variable "cidr_block" {
  default = "10.0.0.0/16"
}
variable "enable_dns_hostnames" {
  type    = bool
  default = true
}
variable "common_tags" {

}
variable "vpc_tags" {
  default = {}
}
variable "internet_gateway_tags" {
  default = {}
}
variable "public_subnet_cidrs" {
  type = list(any)
  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Please provide 2 valid public subnets"
  }
}
variable "public_subnets_tags" {
  default = {}
}
variable "private_subnet_cidrs" {
  type = list(any)
  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "Please provide 2 valid private subnets"
  }
}
variable "private_subnets_tags" {
  default = {}
}
variable "database_subnet_cidrs" {
  type = list(any)
  validation {
    condition     = length(var.database_subnet_cidrs) == 2
    error_message = "Please provide 2 valid database subnets"
  }
}
variable "database_subnets_tags" {
  default = {}
}
variable "db_subnet_tags" {
  default = {}
}

variable "public_route_tags" {
  default = {}
}
variable "private_route_tags" {
  default = {}
}
variable "database_route_tags" {
  default = {}
}
variable "nat_gw_tags" {
  default = {}
}
variable "is_peering_required" {
  type    = bool
  default = false
}
variable "acceptor_vpc_id" {
  default = ""
}
