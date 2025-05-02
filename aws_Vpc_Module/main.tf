resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = local.resource_name
    }
  )
}

#############IGW
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.internet_gateway_tags,
    {
      Name = local.resource_name
    }
  )
}

###Public_subnet
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  availability_zone = local.azs_names[count.index]
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  tags = merge(
    var.common_tags,
    var.public_subnets_tags,
    {
      Name = "${local.resource_name}-public-${local.azs_names[count.index]}"
    }
  )
}

###private_subnet
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  availability_zone = local.azs_names[count.index]
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  tags = merge(
    var.common_tags,
    var.private_subnets_tags,
    {
      Name = "${local.resource_name}-private-${local.azs_names[count.index]}"
    }
  )
}
###database_subnet
resource "aws_subnet" "database" {
  count             = length(var.database_subnet_cidrs)
  availability_zone = local.azs_names[count.index]
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_cidrs[count.index]
  tags = merge(
    var.common_tags,
    var.database_subnets_tags,
    {
      Name = "${local.resource_name}-database-${local.azs_names[count.index]}"
    }
  )
}
#subnet_group
resource "aws_db_subnet_group" "main" {
  name       = local.resource_name
  subnet_ids = aws_subnet.database[*].id

  tags = merge(
    var.common_tags,
    var.db_subnet_tags,
    {
      Name = local.resource_name
    }
  )
}
##EIP
resource "aws_eip" "nat" {
  domain = "vpc"
}
##NAT_GW
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.common_tags,
    var.nat_gw_tags,
    {
      Name = local.resource_name
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

##public_route_table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.common_tags,
    var.public_route_tags,
    {
      Name = "${local.resource_name}-public"
    }
  )
}
##private_route_table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.common_tags,
    var.private_route_tags,
    {
      Name = "${local.resource_name}-private"
    }
  )
}
##database_route_table
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.common_tags,
    var.database_route_tags,
    {
      Name = "${local.resource_name}-database"
    }
  )
}
#public_route
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}
#private_route
resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.main.id
}
#database_route
resource "aws_route" "database" {
  route_table_id         = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.main.id
}
#Public_subnet_association
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
#Private_subnet_association
resource "aws_route_table_association" "private" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
#database_subnet_association
resource "aws_route_table_association" "database" {
  count          = length(var.database_subnet_cidrs)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}


