variable "config" {
  type = object({
    api_name = string
    stage_name = string
    api_description = string
    throttling_rate_limit = number
    throttling_burst_limit = number
    open_api_template_file = any
    open_api_template_variables = any
    logging_level = string
    cloudwatch_log_role_arn = string
    lambda_functions = map(string)
    xray_tracing_enabled = bool
    log_retention_in_days = number
  })
}

variable "tags" {
  default = {}
  type = map(any)
}

variable "app_version" {
  type = string
}
variable "account_info" {
  type = object({
    region = string
    account_id = string
    environment = string
  })
}