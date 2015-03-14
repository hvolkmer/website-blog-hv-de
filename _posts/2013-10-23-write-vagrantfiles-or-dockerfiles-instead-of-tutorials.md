---
title: Stop writing tutorials - start writing Vagrantfiles or Dockerfiles
layout: post
description: Make use of modern tools to make tutorials understandable as well as executable
created_at: 2013-10-23 18:35:13 +0100
---
There are a lot of good tutorials out there about all kinds of system setup stuff. However, it's quite cumbersome and time consuming to go through them and actually set up systems by following them. Also, you have to figure out the correct operating system version etc.

By providing [Vagrantfiles](http://docs.vagrantup.com/v2/vagrantfile/index.html) or [Dockerfiles](http://docs.docker.io/en/latest/use/builder/) (or both) with the tutorial steps encapsulated as either [Chef](http://www.opscode.com/chef/), [Puppet](https://puppetlabs.com/) or even simple bash scripts people can start **using** the system they intend to deploy or try out and don't have to waste time copy/pasting. All the important version info is encapsulated the same way as the tutorial intended, so it will almost certainly work.

To get started, check out examples on github by [searching for Vagrantfile](https://www.google.de/search?q=inurl%3AVagrantfile+site%3Agithub.com) or [Dockerfile](https://www.google.de/search?q=inurl%3ADockerfile+site%3Agithub.com).

So next time you write up how something works (e.g. installing your favourite new database or your new webapp), just provide the Vagrantfile and add useful comments.
