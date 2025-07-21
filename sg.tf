module "security_group" {
  source = "../03-terraform-aws-security-group"
  sg_name = var.sg_name
  vpc_id = local.vpc_id
  common_tags = var.common_tags
  sg_description = var.sg_description
  project_name = var.project_name
  security_group_ingress_rule = var.security_group_ingress_rule
}