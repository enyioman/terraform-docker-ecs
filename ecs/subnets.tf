resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "ig-project"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-2"
  }
}

resource "aws_route_table" "project_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
    Name = "project-rt"
  }
}


resource "aws_route_table_association" "public_route_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.project_rt.id
}

resource "aws_route_table_association" "public_route_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.project_rt.id
}





# # Create 2 Private Subnets
# resource "aws_subnet" "private_subnet_1a_KP19" {
#   vpc_id                  = aws_vpc.TF_KP19.id
#   cidr_block              = "10.0.2.0/24"
#   availability_zone       = "us-east-1a"
#   map_public_ip_on_launch = false
#   tags = {
#     Name = "private subnet 1a_KP19"
#   }
# }
# resource "aws_subnet" "private_subnet_1b_KP19" {
#   vpc_id                  = aws_vpc.TF_KP19.id
#   cidr_block              = "10.0.3.0/24"
#   availability_zone       = "us-east-1b"
#   map_public_ip_on_launch = false
#   tags = {
#     Name = "private subnet 1b_KP19"
#   }
# }