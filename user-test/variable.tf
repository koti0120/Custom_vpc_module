variable "project_name" {
  default = "expense"
}
variable "environment" {
  default = "dev"
}
variable "common_tags" {
  type = map(any)
  default = {
    Name        = "expense"
    Environment = "dev"
    Terraform   = "true"
  }
}
variable "public_subnet_cidrs" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "private_subnet_cidrs" {
  type    = list(any)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}
variable "database_subnet_cidrs" {
  type    = list(any)
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}
variable "is_peering_required" {
  type    = bool
  default = true
}