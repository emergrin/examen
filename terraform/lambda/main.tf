variable "name" {}


############
## IAM ROLE
############

resource "aws_iam_role" "role" {
  name               = "${var.name}-role"
  assume_role_policy = "${data.aws_iam_policy_document.role-policy.json}"
}

############
## IAM ROLE POLICY
############

resource "aws_iam_role_policy" "policy" {
  name = "${var.name}-policy"
  role = "${aws_iam_role.role.id}"

  policy = <<EOF
{

}
EOF
}

####################
# Lambda Functions #
####################

data "archive_file" "XXXXXXXXX" {
  type = "zip"
  source_file = "${path.module}/functions/XXXXXXXXX"
  output_path = "${path.module}/functions/output/${var.name}_XXXXXX.zip"
}

resource "aws_lambda_function" "XXXXXXXXX" {
  filename         = "${data.archive_file.XXXXXXXXX.output_path}"
  function_name    = "${var.name}_convert_to_csv"
  role             = "${aws_iam_role.role.arn}"
  handler          = "XXXXXXXXX"
  source_code_hash = "${base64sha256(file("${data.archive_file.XXXXXXXXX.output_path}"))}"
  runtime          = "XXXXXXXXX"
  timeout          = 5

  environment {
    variables = {

      }
  }

  tags {

  }
}


###########
# Outputs
###########
output "lambda_arn" {
  value = "${aws_lambda_function.XXXXXXXXX.arn}"
}

output "policy_name" {
  value = "${aws_iam_role.policy.name}"
}
