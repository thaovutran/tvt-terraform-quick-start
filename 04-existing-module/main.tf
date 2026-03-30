module "myapp-network" {
  source = "terraform-aws-modules/vpc/aws"

  name   = "${var.env_prefix}-vpc"
  cidr   = var.vpc_cidr_block

  azs                = [var.avail_zone]
  public_subnets     = [var.subnet_cidr_block]
  public_subnet_tags = {
    Name = "${var.env_prefix}-subnet-1"
    VPC  = "${var.env_prefix}-vpc"
  }

  tags = {
    Terraform   = "true"
    Environment = "${var.env_prefix}"
  }
}

module "myapp-server" {
  source                 = "./modules/appsrv"

  vpc_id                 = module.myapp-network.vpc_id
  subnet_id              = module.myapp-network.public_subnets[0]
  avail_zone             = var.avail_zone

  ec2_instance_type      = var.ec2_instance_type
  ec2_ami_name           = var.ec2_ami_name
  ec2_entry_script       = var.ec2_entry_script
  public_key_path        = var.public_key_path
  my_public_ip           = var.my_public_ip

  env_prefix             = var.env_prefix
}
