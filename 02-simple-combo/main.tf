provider "aws" {
  region = "us-east-1"
}

variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable my_public_ip {}
variable ec2_instance_type {}
variable ec2_ssh_key {}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-01" {
  vpc_id            = aws_vpc.myapp-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name: "${var.env_prefix}-subnet-01"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name: "${var.env_prefix}-igw"
  }
}

/*
resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  tags = {
    Name: "${var.env_prefix}-rtb"
  }
}

resource "aws_route_table_association" "asc-rtb-subnet" {
  subnet_id      = aws_subnet.myapp-subnet-01.id
  route_table_id = aws_route_table.myapp-route-table.id
}
*/

resource "aws_default_route_table" "main-route-table" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  tags = {
    Name: "${var.env_prefix}-main-rtb"
  }
}

resource "aws_route_table_association" "asc-rtb-subnet" {
  subnet_id         = aws_subnet.myapp-subnet-01.id
  route_table_id    = aws_default_route_table.main-route-table.id
}

resource "aws_security_group" "myapp-sg" {
  name              = "myapp-sg"
  description       = "The main security group of my application"
  vpc_id            = aws_vpc.myapp-vpc.id

  ingress {
    description     = "Allows SSH access to my public IP"
    from_port       = 22
    to_port         = 22
    protocol        = "TCP"
    cidr_blocks     = [var.my_public_ip]
  }

  ingress {
    description     = "Allows web access to all"
    from_port       = 8080
    to_port         = 8080
    protocol        = "TCP"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image.id
}

resource "aws_instance" "myapp-server" {
  ami           = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.ec2_instance_type
  key_name      = var.ec2_ssh_key

  subnet_id              = aws_subnet.myapp-subnet-01.id
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone      = var.avail_zone
  associate_public_ip_address = true
}
