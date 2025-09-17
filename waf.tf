resource "aws_cloudwatch_log_group" "waf" {
  name              = "aws-waf-logs-${var.name}"
  retention_in_days = 7
  tags              = var.tags
}

module "waf" {
  source  = "cloudposse/waf/aws"
  version = "~> 1.12"

  name        = "${var.name}-waf"
  description = "WAF for API Gateway"

  default_action = "allow"
  visibility_config = {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.name}-waf"
    sampled_requests_enabled   = true
  }

  log_destination_configs = [
    aws_cloudwatch_log_group.waf.arn
  ]

  managed_rule_group_statement_rules = [
    {
      name                     = "AWS-AWSManagedRulesAdminProtectionRuleSet"
      priority                 = 1
      override_override_action = "count"

      statement = {
        name        = "AWSManagedRulesAdminProtectionRuleSet"
        vendor_name = "AWS"
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = "AWS-AWSManagedRulesAdminProtectionRuleSet"
      }
    },
    {
      name            = "AWS-AWSManagedRulesAmazonIpReputationList"
      priority        = 2
      override_action = "count"

      statement = {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      }
    },
    {
      name            = "AWS-AWSManagedRulesCommonRuleSet"
      priority        = 3
      override_action = "count"

      statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      }
    },
    {
      name            = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      priority        = 4
      override_action = "count"

      statement = {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      }
    },
    {
      name            = "AWS-AWSManagedRulesBotControlRuleSet"
      priority        = 5
      override_action = "count"

      statement = {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"

        managed_rule_group_configs = [
          {
            aws_managed_rules_bot_control_rule_set = {
              enable_machine_learning = false
              inspection_level        = "COMMON"
            }
          }
        ]
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = "AWS-AWSManagedRulesBotControlRuleSet"
      }
    },
    {
      name            = "AWS-AWSManagedRulesSQLiRuleSet"
      priority        = 6
      override_action = "count"
      statement = {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
      visibility_config = {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
      }
    }
  ]
}
