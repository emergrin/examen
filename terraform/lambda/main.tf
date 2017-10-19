variable "name" {}


############
## IAM ROLE
############

resource "aws_iam_role" "role" {
  name               = "${var.name}-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

####################
# Lambda Functions #
####################

resource "aws_lambda_function" "examen" {
  filename         = "${path.module}/functions/lambda_nodejs.zip"
  function_name    = "${var.name}_convert_to_csv"
  role             = "${aws_iam_role.role.arn}"
  handler          = "convert.js"
  source_code_hash = "${base64sha256(file("${path.module}/functions/lambda_nodejs.zip"))}"
  runtime          = "nodejs6.10"
  timeout          = 5
}

###########
# Outputs
###########
output "lambda_arn" {
  value = "${aws_lambda_function.examen.arn}"
}

output "policy_name" {
  value = "${aws_iam_role.role.name}"
}
