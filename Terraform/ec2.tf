resource "aws_security_group" "jenkins-sg" {
  vpc_id = aws_vpc.trend-project.id
  name = "jenkins-sg"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins-sever" {
  ami = "ami-0f918f7e67a3323f0"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.sbnet-main.id
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
  key_name = var.key_pair
  iam_instance_profile = aws_iam_instance_profile.jenkins-profile.name
  user_data = file("${path.module}/jenkins-installation.sh")

  tags = {
    Name = "jenkins-server"
  }
}