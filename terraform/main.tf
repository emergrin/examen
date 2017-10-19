#############################
#       variables
#############################

variable "name" {
  type    = "string"
  default = "egimenez_exam"
}

#############################
#       Modules
#############################

module "lambda" {
  source = "./lambda"
  name = "${var.name}"
}

module "s3" {
  source = "./s3"
  name = "${var.name}"
}

#############################
#       Outputs
#############################

output "lambda_name" {
  value = "${module.lambda.lambda_arn}"
}
