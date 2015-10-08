+++
date = "2012-06-04T11:56:37+02:00"
title = "Backporting Debian/Ubuntu packages the easy way."
slug = "backporting-packages-easily"
+++

There is a lot of documentation on the use of Debian/Ubuntu packaging tools, but most of these pages just list 
the options of each of these tools. After fighting with these for some period, I jumped over to the 
`#ubuntu-packaging` IRC channel for help. After explaining my intent of backporting some packages unchanged, 
I was pointed to the [backportpackage](http://manpages.ubuntu.com/manpages/precise/man1/backportpackage.1.html) 
tool:

     backportpackage fetches a package from one distribution release or from a
     specified .dsc path or URL and creates a no-change backport of that package
     to one or more Ubuntu releases release, optionally doing a test build of 
     the package and/or uploading the resulting backport for testing.

This tool comes with the 
[`ubuntu-dev-tools`](http://packages.ubuntu.com/search?keywords=ubuntu-dev-tools&amp;searchon=names&amp;suite=precise&amp;section=all) 
package.

<!--more-->

I needed to backport the ocaml source package from precise (12.04) to all earlier releases up to lucid (10.04). 
For the backport to oneiric, here is the command:

{{< gist id="b0af5b527121b6b543ec" file="backport.sh" >}}

`amplidata-2.5` is the identifier to the PPA as defined in my 
[`dput.cnf`](https://help.launchpad.net/Packaging/PPA/Uploading) file. I also configured the file 
[`~/.devscripts`](http://manpages.ubuntu.com/manpages/precise/man1/devscripts.1.html) with the keys 
`DEBEMAIL`, `DEBFULLNAME` and `DEBSIGN_KEYID`.