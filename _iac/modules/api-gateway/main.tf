data "template_file" "openapi" {
  template = var.config.open_api_template_file
  vars = local.template_variables
}

resource "aws_api_gateway_account" "api_gateway_account" {
  cloudwatch_role_arn = var.config.cloudwatch_log_role_arn
}
resource "aws_api_gateway_rest_api" "api" {
  name        = var.config.api_name
  description = var.config.api_description
  body = data.template_file.openapi.rendered
  api_key_source = "HEADER"
  fail_on_warnings = true
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  triggers = {
    redeployment = sha1(var.app_version)
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [ aws_api_gateway_rest_api.api, aws_lambda_permission.apigw_lambda ]
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = var.config.stage_name
  xray_tracing_enabled = var.config.xray_tracing_enabled
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_access_logs.arn
    format = "$context.identity.sourceIp $context.identity.caller $context.identity.user $context.identity.apiKey $context.requestId [$context.requestTime] \"$context.httpMethod $context.resourcePath $context.protocol\" $context.status context.requestId"
  }

  depends_on = [ aws_api_gateway_account.api_gateway_account,aws_api_gateway_deployment.deployment, aws_api_gateway_rest_api.api ]
}
resource "aws_cloudwatch_log_group" "api_execution_logs" {
  name = "API_Gateway-Execution-Logs_${aws_api_gateway_rest_api.api.id}"
  retention_in_days = var.config.log_retention_in_days
  tags = {
    Name = "${aws_api_gateway_rest_api.api.name}-Execution-Logs"
    Service = "log_group"
  }
}

resource "aws_cloudwatch_log_group" "api_access_logs" {
  name = "API_Gateway-Access-Logs_${aws_api_gateway_rest_api.api.id}"
  retention_in_days = var.config.log_retention_in_days
  tags = {
    Name = "${aws_api_gateway_rest_api.api.name}-Access-Logs"
    Service = "log_group"
  }
}

resource "aws_api_gateway_api_key" "api_key" {
  name = "${var.config.api_name}-api-key"
  description = var.config.api_description
}

resource "aws_api_gateway_usage_plan" "usage_plan" {
  name = "${var.config.api_name}-usage-plan"
  description = var.config.api_description
  api_stages {
    api_id = aws_api_gateway_rest_api.api.id
    stage = aws_api_gateway_stage.stage.stage_name
  }
}

resource "aws_api_gateway_method_settings" "method_settings" {
  method_path = "*/*"
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name = aws_api_gateway_stage.stage.stage_name
  settings {
    throttling_burst_limit = var.config.throttling_burst_limit
    throttling_rate_limit = var.config.throttling_rate_limit
    logging_level = var.config.logging_level
  }
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plan.id
}

resource "aws_lambda_permission" "apigw_lambda" {
  for_each = var.config.lambda_functions
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}