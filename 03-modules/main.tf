resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}

module "myapp-subnet" {
  source                 = "./modules/subnet"
  vpc_id                 = aws_vpc.myapp-vpc.id
  avail_zone             = var.avail_zone
  subnet_cidr_block      = var.subnet_cidr_block
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  env_prefix             = var.env_prefix
}

module "myapp-server" {
  source                 = "./modules/appsrv"
  vpc_id                 = aws_vpc.myapp-vpc.id
  subnet_id              = module.myapp-subnet.subnet.id
  avail_zone             = var.avail_zone
  ec2_instance_type      = var.ec2_instance_type
  ec2_ami_name           = var.ec2_ami_name
  ec2_entry_script       = var.ec2_entry_script
  public_key_path        = var.public_key_path
  my_public_ip           = var.my_public_ip
  env_prefix             = var.env_prefix
}
