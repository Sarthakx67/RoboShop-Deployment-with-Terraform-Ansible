# we create locals.tf to provide output given from module developer as a function
locals {
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  database_subnet_ids = module.vpc.database_subnet_ids
  allow_all_security_group_id = module.security_group.security_group_id
  ips = module.ec2_instance
}
