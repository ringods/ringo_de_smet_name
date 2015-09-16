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
