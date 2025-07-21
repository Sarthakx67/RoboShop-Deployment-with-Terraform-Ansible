module "ec2_instance" {
  for_each = var.instances
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.roboshop-ami.id
  name = "${each.key}"
  instance_type = each.value
  key_name      = "EC2-key"
  vpc_security_group_ids = [local.allow_all_security_group_id]
  subnet_id     = each.key == "web" ? local.public_subnet_ids[0] : local.private_subnet_ids[0] # this means public subnet in 1a regions
  tags = merge(
    var.common_tags
  )
}
module "ec2_ansible" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.roboshop-ami.id
  name = "ansible-server"
  instance_type = "t2.micro"
  key_name      = "EC2-key"
  vpc_security_group_ids = [local.allow_all_security_group_id]
  subnet_id     = local.public_subnet_ids[0] 
  user_data = "${data.template_file.user_data.rendered}"
  tags = merge(
    var.common_tags 
  )
}