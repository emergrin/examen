variable "name" {}

####################
## Bucket          #
####################

resource "aws_s3_bucket" "origen" {
  bucket = "${var.name}-origen"
  acl    = "private"
  region = "eu-west-1"
  versioning {
     enabled = true
  }
  tags {

  }
}

resource "aws_s3_bucket" "destino" {
  bucket = "${var.name}-destino"
  acl    = "private"
  region = "eu-west-1"
  versioning {
     enabled = true
  }
  tags {

  }
}

output "origen" {
  value = "${aws_s3_bucket.origen.arn}"
}

output "origen_id" {
  value = "${aws_s3_bucket.origen.id}"
}

output "destino" {
  value = "${aws_s3_bucket.destino.arn}"
}
