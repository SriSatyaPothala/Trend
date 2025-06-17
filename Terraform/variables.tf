variable "aws_region" {
  type = string
  default = "ap-south-1"
  description = "region in which resources are created"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16" 
}
variable "sbnet_cidr" {
  default = "10.0.1.0/24"
}
variable "availability_zone" {
  default = "ap-south-1a"
}
variable "key_pair" {
  description = "key to login to the EC2"
  default = "key01"
}