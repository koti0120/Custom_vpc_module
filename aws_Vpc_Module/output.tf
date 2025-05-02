# output "azs_info" {
#   value = data.aws_availability_zones.available.names
# }
output "default_vpc" {
  value = data.aws_vpc.default.id
}