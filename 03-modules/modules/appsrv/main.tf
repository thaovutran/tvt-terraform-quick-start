resource "aws_security_group" "myapp-sg" {
  name              = "myapp-sg"
  description       = "The main security group of my application"
  vpc_id            = var.vpc_id

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
    name      = "name"
    values    = [var.ec2_ami_name]
  }

  filter {
    name      = "virtualization-type"
    values    = ["hvm"]
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name     = "server-ssh-key"
  public_key   = file(var.public_key_path)
}

resource "aws_instance" "myapp-server" {
  ami                         = data.aws_ami.latest-amazon-linux-image.id
  instance_type               = var.ec2_instance_type
  key_name                    = aws_key_pair.ssh-key.key_name

  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.myapp-sg.id]
  availability_zone           = var.avail_zone
  associate_public_ip_address = true

  user_data                   = file(var.ec2_entry_script)
  user_data_replace_on_change = true

  tags = {
    Name: "${var.env_prefix}-myappsrv"
  }
}
