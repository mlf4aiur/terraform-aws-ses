locals {
  stripped_mail_from_domain = trim(var.custom_mail_from_domain, ".")
}

data "aws_route53_zone" "ses_domain" {
  name         = var.ses_domain
  private_zone = false
}

data "aws_region" "current" {
}

data "aws_cloudwatch_event_bus" "default" {
  name = "default"
}

resource "aws_sesv2_configuration_set" "this" {
  count = var.create && var.create_configuration_set ? 1 : 0

  configuration_set_name = var.configuration_set_name

  reputation_options {
    reputation_metrics_enabled = true
  }

  suppression_options {
    suppressed_reasons = var.suppressed_reasons
  }

  tags = var.tags
}

resource "aws_sesv2_configuration_set_event_destination" "this" {
  count = var.create && var.create_configuration_set ? 1 : 0

  configuration_set_name = aws_sesv2_configuration_set.this[0].configuration_set_name
  event_destination_name = "EventBridge"

  event_destination {
    event_bridge_destination {
      event_bus_arn = data.aws_cloudwatch_event_bus.default.arn
    }

    enabled              = true
    matching_event_types = var.event_destination_matching_event_types
  }
}

resource "aws_sesv2_email_identity" "this" {
  count = var.create ? 1 : 0

  email_identity = var.ses_domain

  configuration_set_name = var.create_configuration_set ? var.configuration_set_name : null

  tags = var.tags

  depends_on = [aws_sesv2_configuration_set.this]
}

resource "aws_sesv2_email_identity_mail_from_attributes" "this" {
  count = var.create ? 1 : 0

  email_identity = aws_sesv2_email_identity.this[0].email_identity

  behavior_on_mx_failure = var.behavior_on_mx_failure
  mail_from_domain       = local.stripped_mail_from_domain

  depends_on = [aws_sesv2_email_identity.this]
}

# DKIM verification record
resource "aws_route53_record" "dkim" {
  count = 3

  zone_id = data.aws_route53_zone.ses_domain.zone_id
  name    = "${aws_sesv2_email_identity.this[0].dkim_signing_attributes[0].tokens[count.index]}._domainkey"
  type    = "CNAME"
  ttl     = "1800"
  records = ["${aws_sesv2_email_identity.this[0].dkim_signing_attributes[0].tokens[count.index]}.dkim.amazonses.com"]

  depends_on = [aws_sesv2_email_identity.this]
}

# SPF verification record
resource "aws_route53_record" "spf_mail_from" {
  count = var.create ? 1 : 0

  zone_id = data.aws_route53_zone.ses_domain.zone_id
  name    = var.custom_mail_from_domain
  type    = "TXT"
  ttl     = "3600"
  records = ["v=spf1 include:amazonses.com -all"]
}

# Custom MAIL FROM domain verification record
resource "aws_route53_record" "custom_mail_from_mx" {
  count = var.create ? 1 : 0

  zone_id = data.aws_route53_zone.ses_domain.zone_id
  name    = var.custom_mail_from_domain
  type    = "MX"
  ttl     = "600"
  records = ["10 feedback-smtp.${data.aws_region.current.name}.amazonses.com"]
}

# DMARC TXT Record
resource "aws_route53_record" "txt_dmarc" {
  count = var.create && var.enable_dmarc ? 1 : 0

  zone_id = data.aws_route53_zone.ses_domain.zone_id
  name    = "_dmarc.${var.ses_domain}"
  type    = "TXT"
  ttl     = "300"
  records = ["v=DMARC1; p=${var.dmarc_p}; rua=mailto:${var.dmarc_rua};"]
}

data "aws_iam_policy_document" "this" {
  count = var.create && var.enable_cloudwatch_logs ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream"
    ]

    resources = [
      "${aws_cloudwatch_log_group.this[0].arn}:*"
    ]

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com",
        "delivery.logs.amazonaws.com"
      ]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.this[0].arn}:*:*"
    ]

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com",
        "delivery.logs.amazonaws.com"
      ]
    }

    condition {
      test     = "ArnEquals"
      values   = [aws_cloudwatch_event_rule.this[0].arn]
      variable = "aws:SourceArn"
    }
  }
}

resource "aws_cloudwatch_log_group" "this" {
  count = var.create && var.enable_cloudwatch_logs ? 1 : 0

  name              = "/aws/events/${var.eventbridge_rule_name}"
  retention_in_days = 365
}

resource "aws_cloudwatch_log_resource_policy" "this" {
  count = var.create && var.enable_cloudwatch_logs ? 1 : 0

  policy_document = data.aws_iam_policy_document.this[0].json
  policy_name     = "${var.eventbridge_rule_name}-log-publishing-policy"
}

resource "aws_cloudwatch_event_rule" "this" {
  count = var.create && var.enable_cloudwatch_logs ? 1 : 0

  name = var.eventbridge_rule_name

  event_pattern = jsonencode({
    "source" : ["aws.ses"],
    "detail-type" : ["Email Bounced", "Email Complaint Received"],
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "this" {
  count = var.create && var.enable_cloudwatch_logs ? 1 : 0

  rule = aws_cloudwatch_event_rule.this[0].name
  arn  = aws_cloudwatch_log_group.this[0].arn
}
