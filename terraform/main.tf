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


#############################
#       Outputs
#############################

output "lambda_name" {
  value = "${module.lambda.lambda_name}"
}
