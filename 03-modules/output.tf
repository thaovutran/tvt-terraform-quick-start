output "myappsrv-ami_id" {
  value = data.aws_ami.latest-amazon-linux-image.id
}

output "myappsrv-public_ip" {
  value = aws_instance.myapp-server.public_ip
}
