# Create Public Route Table and its Route
resource "aws_route_table" "pub_rtb" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-PubRtb"
    }
  )
}

resource "aws_route_table_association" "pub_rtb_assoc" {
  count          = length(aws_subnet.public[*].id)
  route_table_id = aws_route_table.pub_rtb.id
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_route" "pub_rt" {
  route_table_id         = aws_route_table.pub_rtb.id
  destination_cidr_block = var.all_dest
  gateway_id             = aws_internet_gateway.igw.id
}

# Create Private Route Table and it's Routes
resource "aws_route_table" "priv_rtb" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-PrivRtb"
    }
  )
}

resource "aws_route_table_association" "priv_rtb_assoc" {
  count          = length(aws_subnet.private[*].id)
  route_table_id = aws_route_table.priv_rtb.id
  subnet_id      = aws_subnet.private[count.index].id
}

resource "aws_route" "priv_rt" {
  route_table_id         = aws_route_table.priv_rtb.id
  destination_cidr_block = var.all_dest
  nat_gateway_id         = aws_nat_gateway.natgw.id
}
