# Configuration of the AWS provider is done implicitly by setting the following environment variables:
# AWS_SECRET_ACCESS_KEY
# AWS_ACCESS_KEY_ID
# AWS_DEFAULT_REGION
# https://groups.google.com/d/msg/terraform-tool/GM1QisZ95qc/Pt8JqPVePHAJ

## User & access key to deploy staging and production site from Wercker
resource "aws_iam_user" "ringo_de_smet_name_deployer" {
  name = "ringo_de_smet_name_deployer"
}

resource "aws_iam_access_key" "ringo_de_smet_name_deployer_key" {
  user = "${aws_iam_user.ringo_de_smet_name_deployer.name}"
}
