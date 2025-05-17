variable "create" {
  description = "Whether to create SES resources"
  type        = bool
  default     = true
}

variable "create_configuration_set" {
  description = "Whether to create an SES configuration set"
  type        = bool
  default     = true
}

variable "configuration_set_name" {
  description = "Name of the SES configuration set"
  type        = string
  default     = null
}

variable "suppressed_reasons" {
  description = "A list that contains the reasons that email addresses are automatically added to the suppression list for your account."
  type        = list(string)
  default     = ["COMPLAINT"]
}

variable "ses_domain" {
  description = "Email identity (domain or email) to be verified in SES"
  type        = string
}

variable "tags" {
  description = "Tags to apply to SES resources"
  type        = map(string)
  default     = {}
}

variable "custom_mail_from_domain" {
  description = "Custom MAIL FROM domain for the email identity"
  type        = string
  default     = null

  validation {
    condition     = var.custom_mail_from_domain == null || can(regex("^([a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,}$", var.custom_mail_from_domain))
    error_message = "The custom_mail_from_domain must be a valid subdomain like mail.example.com."
  }
}

variable "behavior_on_mx_failure" {
  description = "he action to take if the required MX record isn't found when you send an email."
  type        = string
  default     = "USE_DEFAULT_VALUE"
}

variable "enable_dmarc" {
  description = "Enable DMARC record creation"
  type        = bool
  default     = true

}

variable "dmarc_p" {
  description = "DMARC policy"
  type        = string
  default     = "none"
}

variable "dmarc_rua" {
  description = "DMARC aggregate report email address"
  type        = string
}

variable "event_destination_matching_event_types" {
  description = "List of event types to match for the event destination"
  type        = list(string)
  default     = ["BOUNCE", "COMPLAINT"]

}

variable "eventbridge_rule_name" {
  description = "Name of the EventBridge rule"
  type        = string
  default     = ""
}

variable "enable_cloudwatch_logs" {
  description = "Whether to enable CloudWatch logging for SES events"
  type        = bool
  default     = true
}
