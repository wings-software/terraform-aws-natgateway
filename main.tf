resource "aws_eip" "nat_eip" {
  vpc  = true
  tags = "${merge(map("Name", "${var.network_name}-private"), var.resource_tags)}"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${var.public_subnet_id}"
  tags          = "${merge(map("Name", "${var.network_name}-private"), var.resource_tags)}"
}

# for each of the private ranges, create a "private" route table.
resource "aws_route_table" "private" {
  count  = "${var.create_route_table ? 1 : 0}"
  vpc_id = "${var.vpc_id}"
  tags   = "${merge(map("Name", "${var.network_name}-private"), var.resource_tags)}"
}

resource "aws_route_table_association" "private" {
  count          = "${var.create_route_table ? 1 : 0}"
  subnet_id      = "${var.private_subnet_id}"
  route_table_id = "${aws_route_table.private.id}"
}

locals {
  route_table_id = "${var.create_route_table ?  aws_route_table.private.id : var.private_subnet_route_table}"
}

# add a nat gateway to each private subnet's route table
resource "aws_route" "private_nat_gateway_route" {
  route_table_id         = "${local.route_table_id}"
  destination_cidr_block = "${var.private_subnet_egress_cidr_block}"
  nat_gateway_id         = "${aws_nat_gateway.nat_gw.id}"
}