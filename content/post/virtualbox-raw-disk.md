+++
date = "2012-08-21"
title = "Virtualbox and raw host disk access"
slug = "virtualbox-raw-disk"
+++

The [VirtualBox forums](http://forums.virtualbox.org) lists 
[numerous](https://forums.virtualbox.org/viewtopic.php?f=8&amp;t=50946&amp;p=233322)
[reports](https://forums.virtualbox.org/viewtopic.php?f=7&amp;t=50280&amp;p=229697)
of people not being able to get VirtualBox to work with raw disk partitions. Initially I bumped into 
the same problems, but got it working in the end.

The setup used in this article is an Ubuntu 12.04 host system with VirtualBox 4.1.18 installed. 
From disk `/dev/sda` the partitions 3 and 4 will be made available to a virtual machine. All virtual machines 
are run as user `virtualbox`. All console samples show clearly the user that runs the command.

<!--more-->

On Ubuntu, raw devices have the following default access rights:

{{< gist id="6ea183c5b86ce95e8d90" file="raw-devices.sh" >}}

To give the `virtualbox` user proper access to the disks, the `disk` group will be extended:

{{< gist id="6ea183c5b86ce95e8d90" file="disk-group-access.sh" >}}

<strong>Before going any further, please make sure that any processes currently running as user virtualbox
are restarted!</strong> 
This is needed for these processes to pick up the changed permissions. Next to the VirtualBox subsystems, 
don't forget to restart the active shell sessions. By adding the `virtualbox` user to the group `disk`,
the change is also persisted over system reboots.

With the proper access in place, we first create the VMDK file pointing to the raw device:

{{< gist id="6ea183c5b86ce95e8d90" file="create-vmdk.sh" >}}

Assuming that the VM `machine1` is already created and contains a storage controller, the raw disk is now 
attached to the virtual machine:

{{< gist id="6ea183c5b86ce95e8d90" file="attach-vmdk.sh" >}}

On successful completion, this command returns no output. If you want to validate that the disk is attached 
correctly, print the virtual machine information:

{{< gist id="6ea183c5b86ce95e8d90" file="attach-vmdk.sh" >}}

That's it!

Please report typos and/or improvements to this article in the comments!
