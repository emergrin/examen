variable "name" {}
variable "s3" {}
variable "id" {}

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

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id   = "AllowExecutionFromCloudWatch"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.examen.function_name}"
  principal      = "s3.amazonaws.com"
  source_arn     = "${var.s3}"
}

resource "aws_sns_topic" "topic" {
  name = "s3-event-notification-topic"

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": {"AWS":"*"},
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:s3-event-notification-topic",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${var.s3}"}
        }
    }]
}
POLICY
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${var.id}"

  topic {
    topic_arn     = "${aws_sns_topic.topic.arn}"
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }
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
