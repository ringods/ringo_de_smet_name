+++
date = "2009-05-05T22:10:20+02:00"
title = "SSH, multiple identities, but no passwords!"
slug = "ssh-multiple-identities-but-no-passwords"
+++

Secure Shell is a great tool for securely connecting between several machines. In the past weeks, I am using it 
more and more, but I was getting tired of typing too much. I found a 
[great article](http://www.symantec.com/connect/articles/ssh-user-identities) on setting up passwordless 
authentication using public/private keys and defining multiple SSH identities, but it still wasn't enough.

<!--more-->

I manage multiple Unix users on [Dreamhost](http://www.dreamhost.com/), a plethora of Linux virtual machines 
at work, running [Jenkins](http://jenkins-ci.org/) builders and two additional machines at home. 
With `ssh-keygen`, you can generate multiple different public/private keypairs (aka an identity). 
The section "Selecting Keys" of the above mentioned article describes how you can select a specific identity for 
connecting to a specific host. The example below shows how to connect to one of my DreamHost user 
accounts in a passwordless manner:

{{< gist id="e13d3c11ed1006b47f5b" file="ssh1.sh" >}}

If you have a long list of accounts, it would definitely be easy to use shortcuts for every combination 
of `user@host` and link that up to a specific SSH identity. Well, this is possible with the use of an SSH 
config file. I found out about this file [here](http://ubuntuforums.org/showthread.php?t=172848) and then 
read more about it in the [man page](http://www.openbsd.org/cgi-bin/man.cgi?query=ssh_config).

When you have `user1` and `user2` as accounts on your remote machine, in my case `boba.dreamhost.com`, and 
having different SSH identities for each user (`dh-user1[.pub]` and `dh-user2[.pub]`), how do you link 
everything together to be able to just type one of the following:

{{< gist id="e13d3c11ed1006b47f5b" file="ssh2.sh" >}}

Actually, this is quite easy. Here is the ~/.ssh/config file in my local account (the account 
I'm making SSH connections <strong>from</strong>):

{{< gist id="e13d3c11ed1006b47f5b" file="ssh-config.conf" >}}

Every section in this file starts with <strong>Host <em>ConnectionName</em></strong> followed by a 
number of connection parameters that are fully described in the man page. In my case, I specify the 
real host name, the username on the remote machine, and the identity file I want to link to that account.

Done!
