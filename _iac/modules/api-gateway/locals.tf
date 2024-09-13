locals {
  lambda_functions = var.config.lambda_functions
  template_variables = merge(local.lambda_functions,var.config.open_api_template_variables)
}