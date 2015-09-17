+++
date = "2008-09-25T11:45:10+02:00"
title = "Setting EC2 Environment Variables in ~/.bash_login"
slug = "setting-ec2-environment-variables-in-bash_login"
author = "Koen"
+++

Section ["Setting up the Tools"](http://docs.amazonwebservices.com/AWSEC2/2007-03-01/GettingStartedGuide/setting-up-your-tools.html) 
of the [Amazon EC2 Getting Started Guide](http://docs.amazonwebservices.com/AWSEC2/2007-03-01/GettingStartedGuide/)
explains how to set up environment variables, so that the EC2 tools find themselves (EC2_HOME), 
Java ($JAVA_HOME), the private access key file (EC2_PRVATE_KEY) and the certificate file (EC2_CERT). 
And they also suggest to change the PATH variable, so that you can run EC2 commands from anywhere.

<!--more-->

Of course, you do not want to set the environment variables every time you want to use the EC2 tools. I added the 
lines below to ~/.bash_login on my Mac, so that the environment variables are set everytime I open a terminal. 
I installed the tools in ~/AWS/ec2-api-tools-1.3-24159 and the private access key file and the certificate file 
reside in ~/.ec2.

{{< gist id="62f21d39075b5342b46a" file="env.sh" >}}
