module "myapp-network" {
  source                 = "./modules/network"
  vpc_cidr_block         = var.vpc_cidr_block
  subnet_cidr_block      = var.subnet_cidr_block
  avail_zone             = var.avail_zone
  env_prefix             = var.env_prefix
}

module "myapp-server" {
  source                 = "./modules/appsrv"
  vpc_id                 = module.myapp-network.vpc.id
  subnet_id              = module.myapp-network.subnet.id
  avail_zone             = var.avail_zone
  ec2_instance_type      = var.ec2_instance_type
  ec2_ami_name           = var.ec2_ami_name
  ec2_entry_script       = var.ec2_entry_script
  public_key_path        = var.public_key_path
  my_public_ip           = var.my_public_ip
  env_prefix             = var.env_prefix
}
