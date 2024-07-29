resource "aws_vpc" "workshop-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "workshop-vpc"
  }

}

resource "aws_subnet" "workshop-public-subnet-01" {
  vpc_id                  = aws_vpc.workshop-vpc.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "workshop-public-subent-01"
  }
}

resource "aws_subnet" "workshop-public-subnet-02" {
  vpc_id                  = aws_vpc.workshop-vpc.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"
  tags = {
    Name = "workshop-public-subent-02"
  }
}

resource "aws_internet_gateway" "workshop-igw" {
  vpc_id = aws_vpc.workshop-vpc.id
  tags = {
    Name = "workshop-igw"
  }
}

resource "aws_route_table" "workshop-public-rt" {
  vpc_id = aws_vpc.workshop-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.workshop-igw.id
  }
}

resource "aws_route_table_association" "workshop-rta-public-subnet-01" {
  subnet_id      = aws_subnet.workshop-public-subnet-01.id
  route_table_id = aws_route_table.workshop-public-rt.id
}

resource "aws_route_table_association" "workshop-rta-public-subnet-02" {
  subnet_id      = aws_subnet.workshop-public-subnet-02.id
  route_table_id = aws_route_table.workshop-public-rt.id
}