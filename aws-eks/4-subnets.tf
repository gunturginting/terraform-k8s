resource "aws_subnet" "private_subnet_1" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "172.16.1.0/24"
    availability_zone = local.zone-1

    tags = {
      "Name"                                                    = "${local.env}-private-${local.zone-1}"
      "kubernetes.io/role/internal-elb"                         = "1"
      "kubernetes.io/cluster/${local.env}-${local.eks_name}"    = "owned"
    }       
}

resource "aws_subnet" "private_subnet_2" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "172.16.2.0/24"
    availability_zone = local.zone-2

    tags = {
      "Name"                                                    = "${local.env}-private-${local.zone-2}"
      "kubernetes.io/role/internal-elb"                         = "1"
      "kubernetes.io/cluster/${local.env}-${local.eks_name}"    = "owned"
    }       
}

resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "172.16.3.0/24"
    availability_zone = local.zone-1
    map_public_ip_on_launch = true

    tags = {
      "Name"                                                    = "${local.env}-public-${local.zone-1}"
      "kubernetes.io/role/elb"                                  = "1"
      "kubernetes.io/cluster/${local.env}-${local.eks_name}"    = "owned"
    }               
}

resource "aws_subnet" "public_subnet_2" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "172.16.4.0/24"
    availability_zone = local.zone-2
    map_public_ip_on_launch = true

    tags = {
      "Name"                                                    = "${local.env}-public-${local.zone-2}"
      "kubernetes.io/role/elb"                                  = "1"
      "kubernetes.io/cluster/${local.env}-${local.eks_name}"    = "owned"
    }               
}