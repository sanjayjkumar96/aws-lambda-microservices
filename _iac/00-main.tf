terraform {

  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.46.0"
    }
  }
}

provider "aws" {
  region     = local.account_info.region
}
module "lambda" {
  source       = "./modules/lambda"
  account_info = local.account_info
  app_version  = var.app_version
  config       = local.config.lambda

}

module "api_gateway" {
  source       = "./modules/api-gateway"
  account_info = local.account_info
  app_version  = var.app_version
  config       = local.config.api_gateway
  depends_on   = [module.lambda]
}
