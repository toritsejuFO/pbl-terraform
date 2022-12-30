resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-Natgw-EIP"
    }
  )
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat_eip.allocation_id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.igw]

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-Natgw"
    }
  )
}
