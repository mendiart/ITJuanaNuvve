
locals {
  az_names           = data.aws_availability_zones.azs.names
  public_subnet_ids  = aws_subnet.public.*.id
  private_subnet_ids = aws_subnet.private.*.id
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name        = "Nuvve-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}
/* PUBLIC SUBNETS */
resource "aws_subnet" "public" {
  count                   = length(local.az_names)
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 1)
  availability_zone       = local.az_names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Nuvve-IG"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Nuvve-Public-Route-Table"
  }
}

resource "aws_route_table_association" "pub_subnet_asociation" {
  count          = length(local.az_names)
  subnet_id      = local.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public_rt.id
}


/* PRIVATE SUBNETS */
resource "aws_subnet" "private" {
  count             = length(slice(local.az_names, 0, 3))
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 1 + length(local.az_names))
  availability_zone = local.az_names[count.index]
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Nuvve-Private-Route-Table"
  }
}

resource "aws_route_table_association" "public-route-table-association" {
  count          = length(local.public_subnet_ids)
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = local.public_subnet_ids[count.index]
}
resource "aws_route_table_association" "private-route-table-association" {
  count          = length(slice(local.private_subnet_ids, 0, 3))
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = local.private_subnet_ids[count.index]
}
