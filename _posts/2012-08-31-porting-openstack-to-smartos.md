---
title: Porting OpenStack to SmartOS
description: First post of a blog series describing the addition of SmartOS as a OpenStack hypervisor
layout: post
category: OpenStack
created_at: 2012-08-31 08:40:03 +0100
---

## General idea

[SmartOS](http://smartos.org) is a modern operating system that was actually created to run cloud orchestration software. Joyent uses it in their commercial Smart Data centre software. So it makes perfect sense to port [OpenStack](http://openstack.org) to it. 

In fact, this idea is so obvious that there is a [blueprint](https://blueprints.launchpad.net/nova/+spec/smartos-support) describing this.

Thijs Metsch wrote a there part ([1](http://www.nohuddleoffense.de/2012/02/12/smartstack-smartos-openstack-part-1/),[2](http://www.nohuddleoffense.de/2012/02/15/smartstack-smartos-openstack-part-2/),[3](http://www.nohuddleoffense.de/2012/02/28/smartstack-smartos-openstack-part-3/)) blog posts series about this endeavour. But it ends where it gets interesting: The part where you actually would start VMs, copy images, set up networking etc.

I built on his work and started where he stopped. 

## The plan

1.	Create a nova Hypervisor backend for SmartOS based on the current folsom (master) branch of Openstack Nova.
2. Integrate networking through Quantum
3. ???
4. Profit


## Current status

I can currently start and stop VMs (both SmartOS zones and KVM based VMs) through the OpenStack API. Glance integration is there (Images from glance will be put into ZFS the way "imgadm" wants them). On the SmartOS side I use the `vmadm` and `imgadm` tools as an integration API. Basic networking also works. Theres quite a lot of work to do to get security groups, floating IPs etc. working.

Here are two screenshots that show how it currently looks:

![Booting a VM](http://blog.hendrikvolkmer.de/assets/2012/08/31/smartos1.png)

![Logging into a OpenStack started Zone](http://blog.hendrikvolkmer.de/assets/2012/08/31/smartos2.png)

Expect more info to come in the next days and weeks.