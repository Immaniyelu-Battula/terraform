resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags =merge(var.vpc_tags,local.common_tags,
  {
    Name = "${local.common_name}.vpc"
  }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.igw_tags,local.common_tags,
  {
    Name = "${local.common_name}.igw"
  }
  )
}


resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  count=length(var.public_subnet_cidrs)
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = local.availability_zone[count.index]
  map_public_ip_on_launch = true
 tags = merge(
  var.public_subnet_tags,
  local.common_tags,
  {
    Name = "${local.common_name}-public-${split("-", local.availability_zone[count.index])[2]}"
  }
)
}


resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main.id
  count=length(var.private_subnet_cidrs)
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.availability_zone[count.index]
  #map_public_ip_on_launch = true
 tags = merge(
  var.private_subnet_tags,
  local.common_tags,
  {
    Name = "${local.common_name}-private-${split("-", local.availability_zone[count.index])[2]}"
  }
)
}


resource "aws_subnet" "database_subnet" {
  vpc_id     = aws_vpc.main.id
  count=length(var.database_subnet_cidrs)
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.availability_zone[count.index]
  #map_public_ip_on_launch = true
 tags = merge(
  var.database_subnet_tags,
  local.common_tags,
  {
    Name = "${local.common_name}-database-${split("-", local.availability_zone[count.index])[2]}"
  }
)
}



/* resource "aws_db_subnet_group" "main" {
  name       = "roboshop-database-subnet-group"
  subnet_ids = aws_subnet.database_subnet[*].id 

  tags = {
    Name = "${local.common_name}-database-subnetgroup"
  }
}
  */

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main.id

  tags = merge(
  var.public_rt_tags,
  local.common_tags,
  {
    Name = "${local.common_name}-public-route-table"
  }
)
}


resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.main.id
 tags = merge(
  var.public_rt_tags,
  local.common_tags,
  {
    Name = "${local.common_name}-private-route-table"
  }
)
  
}

resource "aws_route_table" "database-route-table" {
  vpc_id = aws_vpc.main.id
 tags = merge(
  var.public_rt_tags,
  local.common_tags,
  {
    Name = "${local.common_name}-database-route-table"
  }
)
}


resource "aws_route_table_association" "public-rt-ass" {
  count=length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public-route-table.id
}


resource "aws_route_table_association" "private-rt-ass" {
  count = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnet[count.index].id 
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "database-rt-ass" {

  count = length(var.database_subnet_cidrs)
  subnet_id      = aws_subnet.database_subnet[count.index].id
  route_table_id = aws_route_table.database-route-table.id
}


resource "aws_eip" "nat_eip" {
  domain   = "vpc"
  tags = {
  
    Name = "${local.common_name}-eip"
  }
}


resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "${local.common_name}-nat-gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}


resource "aws_route" "public-route" {
  route_table_id            = aws_route_table.public-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id=aws_internet_gateway.main.id
 
}

resource "aws_route" "private-route" {
  route_table_id            = aws_route_table.private-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id=aws_nat_gateway.main.id
 

}

resource "aws_route" "database-route" {
  route_table_id            = aws_route_table.database-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id=aws_nat_gateway.main.id
 

}