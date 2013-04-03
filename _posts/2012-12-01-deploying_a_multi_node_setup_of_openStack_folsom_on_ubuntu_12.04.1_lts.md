---
title: Deploying a multi node setup of OpenStack Folsom on Ubuntu 12.04.1 LTS with one command
description: A guide to show how to deploy OpenStack Folsom with Chef and Vagrant
layout: post
category: OpenStack
created_at: 2012-12-01 15:45:13 +0100
---

We're going to cook some OpenStack today, so get your ingredients ready:

 - [vagrant][vg]
 - [git][git]
 - [A Hosted Chef Account][hostedchef] (You can use your own chef server, of course. Installing a chef server e.g. via [knife-server][ks] is out of scope of this tutorial, though)
 - [librarian-chef][lib] - `gem install librarian`
 - [spiceweasel][sw] - `gem install spiceweasel`

To be honest, if you count the environment set up commands it's not one command but about five for the whole process. But after the environment set up you can repeat the process using the one setup command over and over again. This is pretty useful for environment specific testing, CI, etc.

> Instead of using vagrant with VirtualBox you can of course use your favourite virtualisation solution for testing or use a bare metal setup. All you need is at least two running machines with Ubuntu 12.04 on them. Instead of `vagrant up` you would then use `knife bootstrap` with the `single-controller` and `single-compute role`.

So let's cook:

## Checkout the Chef cookbooks and Vagrantfile

    git clone https://www.github.com/cloudbau/openstack-chef-repo.git
    librarian-chef update

## Set up Chef server environment

Using hosted chef is the easiest way to get started, but you can of course use your own Chef server. The Vagrantfile uses 2GB per  node at the moment. So be careful not to exceed your RAM if you increase the compute node count.

    vi config.rb # Change the Chef server settings

## Upload cookbooks to chef server

    spiceweasel infrastructure.yml | sh

## Deploy

Now deploy Openstack!

    vagrant up

Get a coffee, tea or whatever you like while it's cooking…

## Use it

Open a browser window at `http://10.0.112.10` to log in to your OpenStack dashboard. The default username and password is "admin" and "secrete". If you want to change that, have a look at the attributes of the keystone cookbook.

## What's next

The [community chef cookbooks][opsoschef] are still under development and the version used here is a slightly modified so that it works with OpenStack Folsom. These changes will be merged back (pull requests are pending) to the community cookbooks and the cookbooks will certainly evolve and also cover OpenStack services like [cinder][cinder] and [quantum][quantum].




[vg]: http://www.vagrantup.com
[git]: http://git-scm.com/
[hostedchef]: http://www.opscode.com/hosted-chef/
[ks]: http://fnichol.github.com/knife-server/
[opsoschef]: http://www.opscode.com/solutions/chef-openstack/
[cinder]: http://wiki.openstack.org/Cinder
[quantum]: http://wiki.openstack.org/Quantum
[lib]: https://github.com/applicationsonline/librarian
[sw]: http://wiki.opscode.com/display/chef/Spiceweasel