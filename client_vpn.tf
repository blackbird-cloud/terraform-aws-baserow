############################################################
# AWS Client VPN Endpoint (blackbird-cloud/client-vpn)
# Assumptions:
# - Module version pinned conservatively (~> 1.0) adjust if newer features needed.
# - Mutual authentication optional: provide root cert chain ARN to enable.
# - Authorization association to private subnets (first two) for access into VPC.
# - Security group kept minimal; tighten as needed (restrict source IP ranges, etc.).
############################################################

locals {
  client_vpn_subnets = try(slice(module.vpc.private_subnets, 0, 2), [])
}

resource "aws_security_group" "client_vpn" {
  count       = var.client_vpn_enabled ? 1 : 0
  name        = "${var.name}-client-vpn"
  description = "Security group for Client VPN endpoint"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from anywhere (consider restricting)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Component = "client-vpn" })
}

resource "aws_cloudwatch_log_group" "client_vpn" {
  count             = var.client_vpn_enabled ? 1 : 0
  name              = "/aws/client-vpn/${var.name}"
  retention_in_days = var.client_vpn_log_retention_days
  tags              = merge(var.tags, { Component = "client-vpn" })
}

data "aws_ssoadmin_instances" "current" {}

module "client_vpn" {
  source  = "blackbird-cloud/client-vpn/aws"
  version = "~> 2.0"
  count   = var.client_vpn_enabled ? 1 : 0

  name              = var.name
  client_cidr_block = var.client_vpn_cidr
  vpc_id            = module.vpc.vpc_id
  private_subnets   = local.client_vpn_subnets

  server_certificate_arn = module.acm.acm_certificate_arn

  # Authentication (placeholder rules - adjust to least privilege)
  auth_rules = [
    {
      cidr = module.vpc.vpc_cidr_block
      description      = "Allow access to entire VPC"
      groups           = ["Baserow"]
    }
  ]

  # SAML metadata (set to empty to disable until provided)
  vpn_saml_metadata        = file("./BaserowVPN.xml")
  vpn_portal_saml_metadata = file("./BaserowVPNPortal.xml")

  # Logging
  cloudwatch_log_group_name = aws_cloudwatch_log_group.client_vpn[0].name

  tags = merge(var.tags, { Component = "client-vpn" })
}

# Notes:
# - Provide var.client_vpn_server_certificate_arn (ACM cert in same region) before enabling.
# - Adjust auth_rules to restrict network access; current rule allows full VPC access.
# - Add SAML metadata values (vpn_saml_metadata / vpn_portal_saml_metadata) when integrating with IdP.
# - Security group currently allows 0.0.0.0/0 on 443; restrict to corporate egress IP ranges for production.
