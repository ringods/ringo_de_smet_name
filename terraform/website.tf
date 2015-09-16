# Configuration of the AWS provider is done implicitly by setting the following environment variables:
# AWS_SECRET_ACCESS_KEY
# AWS_ACCESS_KEY_ID
# AWS_DEFAULT_REGION
# https://groups.google.com/d/msg/terraform-tool/GM1QisZ95qc/Pt8JqPVePHAJ

variable "static_site_bucket_name" {
  description = "S3 Bucket name for the Static Website on AWS"
  default = "static.site.ringo.de-smet.name"
}

resource "template_file" "website_bucket_policy" {
  filename = "website_bucket_policy.json"
  vars {
    bucket = "${var.static_site_bucket_name}"
  }
}

resource "aws_s3_bucket" "ringo_de_smet_name_bucket" {
  bucket = "${var.static_site_bucket_name}"
  acl = "public-read"
  policy = "${template_file.website_bucket_policy.rendered}"

  tags {
    Name = "Static Website for ringo.de-smet.name"
    Generator = "http://gohugo.io"
  }
}

resource "template_file" "deployer_role_policy" {
  filename = "deployer_role_policy.json"
  vars {
    bucket = "${var.static_site_bucket_name}"
  }
}

resource "aws_iam_policy" "ringo_de_smet_name_deployer" {
  name = "${var.static_site_bucket_name}.deployer"
  path = "/"
  description = "Policy allowing to publish a new version of the website to the S3 bucket"
  policy = "${template_file.deployer_role_policy.rendered}"
}

resource "aws_iam_user" "ringo_de_smet_name_deployer" {
  name = "ringo_de_smet_name_deployer"
}

resource "aws_iam_policy_attachment" "deployer-attach-user-policy" {
  name = "test-attachment"
  users = ["${aws_iam_user.ringo_de_smet_name_deployer.name}"]
  policy_arn = "${aws_iam_policy.ringo_de_smet_name_deployer.arn}"
}

resource "aws_iam_access_key" "ringo_de_smet_name_deployer_key" {
  user = "${aws_iam_user.ringo_de_smet_name_deployer.name}"
}
