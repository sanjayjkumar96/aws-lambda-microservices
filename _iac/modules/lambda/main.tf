data "archive_file" "lambda_zip" {
  for_each = var.config
  type        = "zip"
  source_dir  = "${path.root}/${each.value.artifact_path}"
  output_path = "./lambda-${each.value.function_name}-${var.app_version}.zip"
}

resource "aws_lambda_function" "lambda" {
  for_each = var.config
  function_name    = each.value.function_name
  description = each.value.description
  role             = each.value.lambda_role_arn
  handler          = each.value.handler
  runtime          = each.value.runtime
  timeout          = each.value.timeout
  memory_size      = each.value.memory_size
  filename         = data.archive_file.lambda_zip[each.key].output_path
  source_code_hash = data.archive_file.lambda_zip[each.key].output_base64sha256
  publish = each.value.publish
  environment {
    variables = each.value.environment_variables
  }
  vpc_config {
    security_group_ids = each.value.security_group_ids
    subnet_ids         = each.value.subnet_ids
  }
  tracing_config {
    mode = each.value.tracing_mode
  }

  tags = merge(var.tags, 
  { 
    Name = each.value.function_name
  Service = "lambda"
  })
  
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  for_each = var.config
name = "/aws/lambda/${aws_lambda_function.lambda[each.key].function_name}"
retention_in_days = each.value.log_retention_in_days
tags = merge(var.tags, 
{ Name = "/aws/lambda/${aws_lambda_function.lambda[each.key].function_name}"
Service = "log_group"
})
}
