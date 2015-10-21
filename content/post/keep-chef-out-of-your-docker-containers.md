+++
date = "2015-03-14T19:04:51+02:00"
title = "Keep Chef out of your Docker containers"
slug = "keep-chef-out-of-your-docker-containers"
+++

Configuration Management tools can be of good use to provision your Docker containers. But you don't want 
these tools to end up in your Docker images. Using 
[Data Volume Containers](https://docs.docker.com/userguide/dockervolumes/) and 
[Docker Compose](https://docs.docker.com/compose/), we can do this and still have a slim image. 
Here is how you can do it with Chef.

<!--more-->

### TL;DR

Prepare a `docker-compose.yml` file with 3 services: `chef`, `chefdata` and `app`.

* `chef` exposes `/opt/chef` as a volume
* `chefdata` contains the Chef setup (`client.rb`, json, cookbooks) exposed on `/tmp/chef`
* `app` uses the volumes from the former and runs Chef to provision itself
* commit `app` container as an image.
* Use your application image! :-)

# Get an image with Chef installed

I went over to the Docker Hub to search for an image with Chef preinstalled, but exposed as a volume. 
The last part of my request was usually not fulfilled so I created an image myself: 
[`releasequeue/chef-client`](https://registry.hub.docker.com/u/releasequeue/chef-client/)

Since using floating versions like `latest` is not proper release management, I also tag my images with 
the Chef version installed.

# Prepare your application Chef setup

Create a folder containing your `Berksfile` for your application or service:

{{< gist id="5995ea726914f280afb3" file="Berksfile" >}}

Retrieve the cookbook and its dependencies:

{{< gist id="5995ea726914f280afb3" file="berks.sh" >}}

# Cooking your cookbooks container

To run Chef succesfully, we need three parts:

* a config file
* a JSON data file
* the set of cookbooks

We retrieved the cookbook in the previous step. In the chef folder, add a Chef configuration file and a 
JSON data file to complete the setup:

{{< gist id="5995ea726914f280afb3" file="zero.rb" >}}

{{< gist id="5995ea726914f280afb3" file="first-boot.json" >}}

With all these parts in place, we can create another data volume container containing all of the above. 
Put a `Dockerfile` in the chef folder with these contents:

{{< gist id="5995ea726914f280afb3" file="Chef-Dockerfile" >}}

# Provisioning the application container

Now we are ready to create our application container. Add your application `Dockerfile` to the top-level project folder:

{{< gist id="5995ea726914f280afb3" file="Dockerfile" >}}

To get the 3 containers running together, we use `docker compose` with this input file:

{{< gist id="5995ea726914f280afb3" file="docker-compose.yml" >}}

and just run `docker-compose up`. You should see all three containers be created and Chef running from 
the last one. Once it has done, the containers all stop gracefully.

# Baking the application image

We have to find the container id of our application container after running docker compose:

{{< gist id="5995ea726914f280afb3" file="docker-compose.sh" >}}

Let's commit our application container to an image and tag it:

{{< gist id="5995ea726914f280afb3" file="create-image.sh" >}}

# Run your application

We have our provisioned image, so let's start our application:

{{< gist id="5995ea726914f280afb3" file="run-app.sh" >}}

Since the volumes of Chef or the cookbooks are no longer there, this image is free of any provisioning tools 
and much smaller as a result.

Happy container cooking!
