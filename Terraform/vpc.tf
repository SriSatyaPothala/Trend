# creating vpc to host jenkins server
resource "aws_vpc" "trend-project" {
  cidr_block = var.vpc_cidr

  tags = {
    name = "trend_proj"
  }
}
# creating ig for vpc to allow inbound and outbound internet connection
resource "aws_internet_gateway" "ig-vpc" {
  vpc_id = aws_vpc.trend-project.id                 
}
# creating public subnet inside vpc
resource "aws_subnet" "sbnet-main" {
  vpc_id = aws_vpc.trend-project.id
  cidr_block = var.sbnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
}
 # creating route table 
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.trend-project.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig-vpc.id
  }
}
 # creating association to the route table to make the subnet public 
resource "aws_route_table_association" "rt_to_sbnet" {
  subnet_id = aws_subnet.sbnet-main.id
  route_table_id = aws_route_table.public_rt.id
}
