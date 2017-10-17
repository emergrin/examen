#############################
#       variables
#############################

variable name = "egimenez_exam"


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
  value = "${module.lambda.lambda_name}"
}
