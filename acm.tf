resource "aws_route53_zone" "public" {
  name = var.domain_name
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "6.1.0"

  domain_name = var.domain_name
  zone_id     = aws_route53_zone.public.zone_id

  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain_name}",
  ]

  wait_for_validation = true

  tags = {
    Name = var.domain_name
  }
}
