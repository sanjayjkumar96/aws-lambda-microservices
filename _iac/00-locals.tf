locals {
  account_info = {
    region      = "ap-south-1"
    account_id  = "339713070060"
    environment = var.environment
  }
  config = {
    api_gateway = {
      "api_name"               = "My-First-API"
      "stage_name"             = "dev"
      "api_description"        = "My First API Integration with Lambda"
      "throttling_rate_limit"  = 1000
      "throttling_burst_limit" = 1000
      "open_api_template_file" = file("../api-spec/my-first-api-template.yml")
      "open_api_template_variables" = {
        account_id  = local.account_info.account_id
        environment = local.account_info.environment
        region      = local.account_info.region
      }
      "logging_level"           = "INFO"
      "cloudwatch_log_role_arn" = "arn:aws:iam::${local.account_info.account_id}:role/AmazonAPIGatewaytoPushLogsRole"
      "lambda_functions" = {
        hello-world-fn = "hello-world-fn-${local.account_info.environment}"
      }
      "xray_tracing_enabled"  = false
      "log_retention_in_days" = 30
    }
    lambda = {
      "hello-world-fn" = {
        "function_name"         = "hello-world-fn-${local.account_info.environment}"
        "lambda_role_arn"       = "arn:aws:iam::${local.account_info.account_id}:role/LambdaBasicRole"
        "handler"               = "index.handler"
        "runtime"               = "nodejs18.x"
        "artifact_path"         = "../dist/hello-world-fn"
        "timeout"               = 300
        "memory_size"           = 128
        "publish"               = true
        "log_retention_in_days" = 30
        "tracing_mode"          = "Active"
        "subnet_ids" = []
        "security_group_ids" = []
        "description"           = "Hello world Function using Express Monorepo Structure"
        "environment_variables" = {
          ENV = local.account_info.environment
        }
      }
    }
  }
}
