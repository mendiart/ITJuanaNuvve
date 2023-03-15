locals {
  nat_gateways = aws_nat_gateway.nat-gw.*.id
}
resource "aws_eip" "elastic-ip-for-nat-gw" {
  vpc                       = true
  associate_with_private_ip = cidrsubnet(var.vpc_cidr, 16, 5)
  tags = {
    Name = "Production-EIP"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.elastic-ip-for-nat-gw.id
  subnet_id     = local.private_subnet_ids[0]

  tags = {
    Name = "Production-NAT-GW"
  }
  depends_on = [
    aws_eip.elastic-ip-for-nat-gw
  ]
}

resource "aws_route" "nat-gw-route" {
  count                  = length(local.nat_gateways)
  route_table_id         = aws_route_table.private_rt.id
  nat_gateway_id         = local.nat_gateways[count.index]
  destination_cidr_block = "0.0.0.0/0"
}
