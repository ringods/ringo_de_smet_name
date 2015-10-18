# ringo.de-smet.name
My blog, powered by [Hugo](http://gohugo.io/), with [Casper](https://github.com/vjeantet/hugo-theme-casper) theme.

## Setup

Deployment on AWS is done via [Terraform](http://www.terraform.io). It configures the complete AWS infrastructure
and triggers any required provisioning. Once this setup is done, we can start deploying Docker containers on it.

The Terraform state for an environment is stored in an S3 bucket using the 
[Terraform Remote State](http://www.terraform.io/docs/commands/remote-config.html) functionality.

AWS Region: eu-west-1
AWS S3 Bucket: atriso-terraform-state

To configure the S3 remote state bucket:

    $ terraform remote config -backend=s3 -backend-config="bucket=atriso-terraform-state" -backend-config="key=static_site_ringo.tfstate" -backend-config="region=eu-west-1"

Make sure that the S3 bucket for the Terraform state is created first.

Now we can try out and execute with:

    $ terraform plan
    $ terraform apply

Handle with care!

## Remarks

On S3, if you set `index.html` as the index object, it is valid for the root and all subdirectories.
The default behavior for CloudFront is 
[not like that](http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/DefaultRootObject.html).
However, if you set the Origin of the CloudFront distribution to the S3 bucket domain, including the AWS region,
then CloudFront follows the S3 setting. I found 
[this solution](http://stackoverflow.com/questions/15309113/amazon-cloudfront-doesnt-respect-my-s3-website-buckets-index-html-rules)
on StackOverflow.
 