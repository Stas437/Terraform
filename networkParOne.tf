resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "vpc_for_home"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main_vpc.id
}


resource "aws_subnet" "publicOne" {
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main_vpc.id
}

resource "aws_subnet" "publicTwo" {
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main_vpc.id
}

resource "aws_route_table" "publicOne" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    "name" = "my personal router for publick ip "
  }

}

resource "aws_route_table_association" "publicOne" {
  route_table_id = aws_route_table.publicOne.id
  subnet_id      = (aws_subnet.publicOne.id)
}

resource "aws_route_table_association" "publicTwo" {
  route_table_id = aws_route_table.publicOne.id
  subnet_id      = (aws_subnet.publicTwo.id)
}
