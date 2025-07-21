module "vpc" {
  source = "git::https://github.com/Sarthakx67/terraform-aws-vpc-module.git"
  # creating vpc
  cidr_block = var.cidr_block 
  common_tags = var.common_tags
  project_name = var.project_name
  vpc_tags = var.vpc_tags
  # creating internet gateway
  igw_tags = var.igw_tags
  # creating public subnet
  public_subnet_cidr_block = var.public_subnet_cidr_block
  # creating private subnet
  private_subnet_cidr_block = var.private_subnet_cidr_block
  #creating database subnet
  database_subnet_cidr_block = var.database_subnet_cidr_block
}

