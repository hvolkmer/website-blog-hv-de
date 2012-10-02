---
title: Reducing development-production parity for OpenStack development with SmartOS zones
description: Thinking about deployment at development time pays off. SmartOS zones help a lot.
layout: post
--- 
Reducing [Dev/prod parity](http://www.12factor.net/dev-prod-parity) has several advantages that are listed and explained at the linked page. Without a useful reduction of the parity [Continuous delivery](http://continuousdelivery.com/) is impossible or at least akin to madness.

In context of OpenStack development and deployment dev/prod parity seems to be not one of the most addresses problems right now. From what I hear the de facto standard development environment for OpenStack is [devstack](http://www.devstack.org). Devstack is a perfect fit to get OpenStack running and to start developing but it is not the way people deploy OpenStack in production. This leads to all kinds of problems that could be avoided.

Reducing dev/prod parity is very important and that's why I think of it at this point even though a SmartOS based OpenStack production deployment seems to be a thing of the future right now.

## Development setup

It turns out that SmartOS is fantastic to address this problem. Let's see how the current development setup looks like:

![Single Host Setup](/assets/2012/09/14/single-host.png)

I basically start up `nova-compute` in the global zone to have access to `vmadm` and start all the other services in separate zones. At first this seems to be a hassle and to much for development. But it forces you to think of all the things that will go wrong in production. For example: `nova-compute` needs to be able to access the database (which will be fixed in the future). So I need to setup the mysql credentials in a way to support that.

## Multi node setup

How would this model look like in a more production like environment? 

![Multi Host setup](/assets/2012/09/14/multi-host.png)

You can see that the basic service separation is the same. From an service standpoint it does not matter if the zones were deployed on a development host or on several physical hosts in the multi node production case.

Being able to develop OpenStack in a production like setup will reduce the likelihood of surprises when it comes to deployment. SmartOS zones help a lot to achieve this goal.

## Do you want to know more?

If you want to know more about SmartOS and OpenStack, [vote for my talk proposal "Porting OpenStack to SmartOS"](https://www.openstack.org/summit/san-diego-2012/vote-for-speakers/) at the upcoming OpenStack San Diego Summit.