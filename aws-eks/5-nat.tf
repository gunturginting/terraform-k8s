resource "aws_eip" "eip" {
    domain = "vpc"

    tags = {
      "Name" = "${local.env}-eip-nat"
    }
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.eip.id
    subnet_id = aws_subnet.public_subnet_1.id

    tags = {
      "Name" = "${local.env}-nat-gateway"
    }

    depends_on = [ aws_internet_gateway.igw ]
}