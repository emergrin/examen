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

module "s3" {
  source = "./s3"
  name = "${var.name}"
}

module "lambda" {
  source = "./lambda"
  name = "${var.name}"
  s3   = "${module.s3.origen}"
  id   = "${module.s3.origen_id}"
}


#############################
#       Outputs
#############################

output "lambda_name" {
  value = "${module.lambda.lambda_arn}"
}
