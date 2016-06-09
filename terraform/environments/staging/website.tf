################################################################################################################
# Complete setup for the Staging version of the Hugo powered personal blog
################################################################################################################

module "site_main" {
  source = "github.com/ringods/terraform-website-s3-cloudfront-route53//site-main"

  region = "eu-west-1"
  domain = "ringo.staging.de-smet.name"
  duplicate-content-penalty-secret = "E5dLhoHQrcxv2FRWpEft"
  deployer = "ringo_de_smet_name_deployer"
  acm-certificate-arn = "arn:aws:acm:us-east-1:511711512731:certificate/59d78e06-1ad8-47ba-909a-d7335fbc250f"

//  log_bucket = "logs-releasequeue-production"
//  log_bucket_prefix = "website-releasequeue/"
}

module "dns_main" {
  source = "github.com/ringods/terraform-website-s3-cloudfront-route53//r53-cname"

  domain = "ringo.staging.de-smet.name"
  target = "${module.site_main.website_cdn_hostname}"
  route53_zone_id = "ZK9VI1HPN7WWO"
}
