module "security_group" {
  source = "git::https://github.com/Sarthakx67/RoboShop-Security-Group-Module.git"
  sg_name = var.sg_name
  vpc_id = local.vpc_id
  common_tags = var.common_tags
  sg_description = var.sg_description
  project_name = var.project_name
  security_group_ingress_rule = var.security_group_ingress_rule
}