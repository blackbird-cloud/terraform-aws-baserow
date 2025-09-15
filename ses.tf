############################################################
# AWS SES setup for Baserow
############################################################

# Replace with your verified domain or email
variable "ses_identity" {
  description = "SES identity (domain or email) to verify and use for sending."
  type        = string
  default     = "baserow-webinar.blackbird.cloud"
}

resource "aws_sesv2_email_identity" "main" {
  email_identity         = var.ses_identity
  configuration_set_name = aws_sesv2_configuration_set.main.configuration_set_name
}

resource "aws_sesv2_configuration_set" "main" {
  configuration_set_name = replace(var.ses_identity, ".", "-")

  delivery_options {
    max_delivery_seconds = 300
    tls_policy           = "REQUIRE"
  }

  reputation_options {
    reputation_metrics_enabled = true
  }

  sending_options {
    sending_enabled = true
  }

  suppression_options {
    suppressed_reasons = ["BOUNCE", "COMPLAINT"]
  }
}

resource "aws_sesv2_configuration_set_event_destination" "main" {
  configuration_set_name = aws_sesv2_configuration_set.main.configuration_set_name
  event_destination_name = "main"

  event_destination {
    cloud_watch_destination {
      dimension_configuration {
        default_dimension_value = "default"
        dimension_name          = "default"
        dimension_value_source  = "MESSAGE_TAG"
      }
    }

    enabled              = true
    matching_event_types = ["REJECT", "BOUNCE", "COMPLAINT", "DELIVERY"]
  }
}

resource "aws_route53_record" "dkim" {
  count = 3

  zone_id = aws_route53_zone.public.zone_id
  name    = "${aws_sesv2_email_identity.main.dkim_signing_attributes[0].tokens[count.index]}._domainkey.${var.ses_identity}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_sesv2_email_identity.main.dkim_signing_attributes[0].tokens[count.index]}.dkim.amazonses.com"]

  depends_on = [aws_sesv2_email_identity.main]
}

resource "aws_route53_record" "dmarc" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "_dmarc.${var.ses_identity}"
  type    = "TXT"
  ttl     = "60"
  records = ["v=DMARC1; p=none;"]
}

resource "aws_sesv2_email_identity_policy" "smtp" {
  email_identity = aws_sesv2_email_identity.main.email_identity
  policy_name    = "smtp"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ses.amazonaws.com"
        },
        "Action" : "ses:SendEmail",
        "Resource" : aws_sesv2_email_identity.main.arn
      }
    ]
  })
}

resource "aws_iam_user" "baserow_smtp" {
  name = "baserow-smtp"
  tags = var.tags
}

resource "aws_iam_user_policy" "baserow_smtp_send" {
  name = "baserow-smtp-send"
  user = aws_iam_user.baserow_smtp.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
            "ses:SendEmail",
            "ses:SendRawEmail"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_access_key" "baserow_smtp" {
  user = aws_iam_user.baserow_smtp.name
}
