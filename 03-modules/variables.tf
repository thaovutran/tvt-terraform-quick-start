variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "my_public_ip" {}
variable "ec2_ami_name" {}
variable "ec2_instance_type" {}
variable "ec2_ssh_key" {}
variable "ec2_entry_script" {
  type    = string
  default = "./src/entry-script.sh"
}
variable "public_key_path" {}
variable "private_key_path" {}
