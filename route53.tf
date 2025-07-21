module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  zone_name = var.zone_name
  for_each = local.ips
  records = [
    {
        name    = "${each.key}"
        type    = "A"
        ttl     = 1
        records = [
            each.key == "web" ? each.value.public_ip : each.value.private_ip
        ]
    }
  ]
}