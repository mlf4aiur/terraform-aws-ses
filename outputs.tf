output "aws_sesv2_email_identity_name" {
  value = format("_amazonses.%s", var.ses_domain)
}

output "aws_sesv2_email_identity_arn" {
  value = aws_sesv2_email_identity.this[0].arn
}
