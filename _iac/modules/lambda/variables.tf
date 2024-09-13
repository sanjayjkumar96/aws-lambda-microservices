variable "tags" {
  default = {}
  type = map(any)
}

variable "account_info" {
  type = object({
    region = string
    account_id = string
    environment = string
  })
}

variable "app_version" {
  type = string
}

variable "config" {
  type = map(object({
    function_name = string
    artifact_path = string
    lambda_role_arn = string
    handler = string
    runtime = string
    timeout = number
    memory_size = number
    publish = bool
    description = string
    log_retention_in_days = number
    environment_variables = any
    tracing_mode = string
    subnet_ids = list(string)
    security_group_ids = list(string)

  }))
}