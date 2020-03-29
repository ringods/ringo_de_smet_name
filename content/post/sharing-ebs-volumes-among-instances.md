+++
date = "2008-09-25"
title = "Sharing EBS Volumes Among Instances"
slug = "sharing-ebs-volumes-among-instances"
author = "Koen"
+++

In this post I share an experiment to create an EBS volume, to attach it to an EC2 instance, to mount it in the 
instance, to put a file on it, to unmount it, and to detach it. Afterwards the volume will be mounted in another 
instance (while the first instance has been terminated, because attaching volumes to different instances at the 
same time is impossible).

<!--more-->

I followed the instructions given in the 
[Elastic Block Storage Feature Guide](http://developer.amazonwebservices.com/connect/entry!default.jspa?categoryID=112&amp;externalID=1667).

### Starting an Instance

Let's see which AMIs are available:

{{< gist id="d02d07909d9c8a5edebd" file="ec2-describe-images.sh" >}}

I launch ami-c6c622af with Elasticfox. Let's check the status of the instance with the command line tools:

{{< gist id="d02d07909d9c8a5edebd" file="ec2-describe-instances.sh" >}}

Important to note for later is the availability zone in which the instance is running, because volumes can ony be 
attached to instances when they live in the same availability zone.

### Create the Volume

Create a volume of 1 GB in the same availability zone in which the instance resides:

{{< gist id="d02d07909d9c8a5edebd" file="ec2-create-volume.sh" >}}

Check the status of the volume:

{{< gist id="d02d07909d9c8a5edebd" file="ec2-describe-volumes.sh" >}}

The volume is available now. Time to use it!

### Attaching the Volume

Attach the newly created volume as device /dev/sdh to the running instance:

{{< gist id="d02d07909d9c8a5edebd" file="ec2-attach-volume.sh" >}}

The command returns saying that the volume is attaching. Let's check the status:

{{< gist id="d02d07909d9c8a5edebd" file="ec2-describe-volumes-2.sh" >}}

While the volume was "available" and "attaching" before, now it is "in-use" and "attached".

### Formatting the Volume

Open another terminal. Connect to the instance via ssh:

{{< gist id="d02d07909d9c8a5edebd" file="connect-to-ec2-vm.sh" >}}

Looking at the contents of /dev reveals that the volume is available as device "sdh":

{{< gist id="d02d07909d9c8a5edebd" file="dev-contents.sh" >}}

Since a new volume is not formatted, we do that first:

{{< gist id="d02d07909d9c8a5edebd" file="format-volume.sh" >}}

Mounting the Volume

Finally, the volume is ready to be mounted in the instance:

{{< gist id="d02d07909d9c8a5edebd" file="mount-volume.sh" >}}

Let's check whether everything is as expected:

{{< gist id="d02d07909d9c8a5edebd" file="check-mount.sh" >}}

That looks okay.

### Put a file on the volume

Using vi, I created a file named "readme" with this contents:

{{< gist id="d02d07909d9c8a5edebd" file="demo-file.txt" >}}

Unmounting the Volume

Before we stop the instance, we have to unmount the volume. From the 
[Elastic Block Storage Feature Guide](http://developer.amazonwebservices.com/connect/entry!default.jspa?categoryID=112&amp;externalID=1667):

<em>A volume must be unmounted inside the instance before being detached. Failure to do so will result in damage to 
the file system or the data it contains.</em>

{{< gist id="d02d07909d9c8a5edebd" file="unmount-volume.sh" >}}

Remember to cd out of the volume, otherwise you will get an error message "umount: /mnt/data-store: device is busy"

### Detach the Volume

From the Feature Guide: <em>An Amazon EBS volume can be detached from an instance by either explicitly detaching 
the volume or terminating the instance.</em> Let's do it by explicitly detaching it:

{{< gist id="d02d07909d9c8a5edebd" file="detach-volume.sh" >}}

Soon the status of the volume changes form "detaching" to "available":

{{< gist id="d02d07909d9c8a5edebd" file="ec2-describe-volumes-3.sh" >}}

Mounting the Volume in Another Instance

Now do all the steps over again to start a new image and mount the volume. Because the volume resides in availability 
zone "us-east-1c" and instances and volumes have to live in the same availability zone, we have to launch the instance 
in "us-east-1c".

{{< gist id="d02d07909d9c8a5edebd" file="launch-new-instance.sh" >}}

Now start anoher terminal to connect to the instance:

{{< gist id="d02d07909d9c8a5edebd" file="mount-new-instance.sh" >}}

The file we created earlier was on the volume and we could read it. This proves that we can share volumes among instances.

To clean up:

{{< gist id="d02d07909d9c8a5edebd" file="cleanup.sh" >}}
