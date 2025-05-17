## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_route53_record.custom_mail_from_mx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.dkim](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.spf_mail_from](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.txt_dmarc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_sesv2_configuration_set.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_configuration_set) | resource |
| [aws_sesv2_configuration_set_event_destination.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_configuration_set_event_destination) | resource |
| [aws_sesv2_email_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_email_identity) | resource |
| [aws_sesv2_email_identity_mail_from_attributes.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_email_identity_mail_from_attributes) | resource |
| [aws_cloudwatch_event_bus.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudwatch_event_bus) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.ses_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_behavior_on_mx_failure"></a> [behavior\_on\_mx\_failure](#input\_behavior\_on\_mx\_failure) | he action to take if the required MX record isn't found when you send an email. | `string` | `"USE_DEFAULT_VALUE"` | no |
| <a name="input_configuration_set_name"></a> [configuration\_set\_name](#input\_configuration\_set\_name) | Name of the SES configuration set | `string` | `null` | no |
| <a name="input_create"></a> [create](#input\_create) | Whether to create SES resources | `bool` | `true` | no |
| <a name="input_create_configuration_set"></a> [create\_configuration\_set](#input\_create\_configuration\_set) | Whether to create an SES configuration set | `bool` | `true` | no |
| <a name="input_custom_mail_from_domain"></a> [custom\_mail\_from\_domain](#input\_custom\_mail\_from\_domain) | Custom MAIL FROM domain for the email identity | `string` | `null` | no |
| <a name="input_dmarc_p"></a> [dmarc\_p](#input\_dmarc\_p) | DMARC policy | `string` | `"none"` | no |
| <a name="input_dmarc_rua"></a> [dmarc\_rua](#input\_dmarc\_rua) | DMARC aggregate report email address | `string` | n/a | yes |
| <a name="input_enable_cloudwatch_logs"></a> [enable\_cloudwatch\_logs](#input\_enable\_cloudwatch\_logs) | Whether to enable CloudWatch logging for SES events | `bool` | `true` | no |
| <a name="input_enable_dmarc"></a> [enable\_dmarc](#input\_enable\_dmarc) | Enable DMARC record creation | `bool` | `true` | no |
| <a name="input_event_destination_matching_event_types"></a> [event\_destination\_matching\_event\_types](#input\_event\_destination\_matching\_event\_types) | List of event types to match for the event destination | `list(string)` | <pre>[<br/>  "BOUNCE",<br/>  "COMPLAINT"<br/>]</pre> | no |
| <a name="input_eventbridge_rule_name"></a> [eventbridge\_rule\_name](#input\_eventbridge\_rule\_name) | Name of the EventBridge rule | `string` | `""` | no |
| <a name="input_ses_domain"></a> [ses\_domain](#input\_ses\_domain) | Email identity (domain or email) to be verified in SES | `string` | n/a | yes |
| <a name="input_suppressed_reasons"></a> [suppressed\_reasons](#input\_suppressed\_reasons) | A list that contains the reasons that email addresses are automatically added to the suppression list for your account. | `list(string)` | <pre>[<br/>  "COMPLAINT"<br/>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to SES resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_sesv2_email_identity_arn"></a> [aws\_sesv2\_email\_identity\_arn](#output\_aws\_sesv2\_email\_identity\_arn) | n/a |
| <a name="output_aws_sesv2_email_identity_name"></a> [aws\_sesv2\_email\_identity\_name](#output\_aws\_sesv2\_email\_identity\_name) | n/a |
