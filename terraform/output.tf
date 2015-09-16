output "deployer_access_key" {
  value = "${aws_iam_access_key.ringo_de_smet_name_deployer_key.id}"
}

output "deployer_secret_key" {
  value = "${aws_iam_access_key.ringo_de_smet_name_deployer_key.secret}"
}
