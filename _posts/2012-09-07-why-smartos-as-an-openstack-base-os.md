---
title: Why SmartOS as an OpenStack base operating system?
description: A brief overview over the SmartOS feature that make it a good fit as an OpenStack base operating system
layout: post
category: OpenStack
created_at: 2012-09-07 08:02:13 +0100
---

When SmartOS was first announced about a year ago, I downloaded the ISO, booted it in VMware, logged in and then… nothing. What is this? It's small, it is not supposed to be installed on disk. What do I do with it? What is so special about it? It is just an Illumos distro - a small and strange one. I did not get it.

I am now [porting OpenStack to SmartOS](http://blog.hendrikvolkmer.de/2012/08/31/porting-openstack-to-smartos/) and I think it is a perfect fit for that purpose. It is truly a Cloud OS. What does that mean? Let's go through the features of SmartOS that make it a perfect fit to be run as a Cloud Base OS. 

## ZFS

The [ZFS](http://en.wikipedia.org/wiki/ZFS) storage model is based on Copy-On-Write which means that snapshots and clones are essentially free. This is fantastic for a Cloud compute node. Say you have a small set of defined VM base images and then spin up 20 VMs of Ubuntu 12.04. The Ubuntu image takes up about 500 MB of disk space. How much do 20 VMs of Ubuntu 12.04 use? Simple math right? Well, with ZFS these 20 VMs take 500 and a few MB. Total. Of course as the instances diverge this ratio gets lower but it is still impressive and very useful. Also spinning up Instances means you only have to clone the base image in ZFS which will take a few seconds the most, compared to copying it on a traditional file system. Somewhere in the internets I can hear someone shouting: "My SAN does the same thing since the 80ies, smartass". Sure, but it costs quite a bit more and you also get a lot of [complexity](http://radar.oreilly.com/2012/04/complexity-vs-simplicity.html).

The local storage needs for the base operating system get even better when you use Zones (see below).

## DTrace

While the open source SmartOS (to my knowledge) lacks the cool graphical reporting possibilities based on DTrace it still contains the real [DTrace](http://dtrace.org/blogs/about/) capabilities. Everyone who had to hunt a memory leak or strange process behaviour in production will know what it is worth to have a good tracing capability at hand. DTrace will enable you to find performance and other problems that in a stable and very low overhead way.

## Zones

Zones let you securely partition your OS without the overhead of another hypervisor ([OS level virtualisation](http://en.wikipedia.org/wiki/Operating_system-level_virtualization)). In SmartOS a zone is always the outer "hull" of virtualisation. Either inside is just another SmartOS, or a qemu process with KVM that runs any other operating system. In combination with ZFS and Crossbow this is fantastic basis for virtual environments.

As Zones have minimal overhead they provide an ideal foundation for PaaS services like databases, load balancers etc. In an OpenStack context this would allow us to just use a special VM image that translates to a zone for a DB. We could thus avoid the whole [RedDwarf/RedDwarf lite-back-and-forth-disaster](https://lists.launchpad.net/openstack/msg15314.html). 

## KVM

Using KVM allows us to run (almost) any x86 operating system using the Intel VT-D, VT-X extensions with very little overhead. SmartOS has integrated KVM in a way that is easy to use. Actually I'm pretty glad that they did not use libvirt as abstraction layer but created their own.

## SMF - Service Management Facility

With [SMF](http://en.wikipedia.org/wiki/Service_Management_Facility) you can define services, dependencies and let SMF manage them for you. I do believe that dependencies are important and a good way to model things for services (in contrast to what the  [Upstart](http://upstart.ubuntu.com/cookbook/#id74) designers think). Managing services in this model has been proving to work well e.g. with the [Erlang Supervision Tree](http://www.erlang.org/doc/design_principles/des_princ.html). With SMF you can define dependencies and restart behaviours of services as well as alerts when stuff goes awry.

## Crossbow

Illumos comes with its own network virtualisation layer (basically a virtual switch) called Crossbow. In SmartOS the network virtualisation is integrated in the `vmadm` tool and works seamlessly. The virtualisation is based on VLANs: Each tenant will get their own VLAN. Crossbow was way ahead of the competition when it was released. With [OpenVSwitch](http://openvswitch.org) the Linux world has caught up and maybe even surpassed Crossbow. It will be interesting to see how the development of these technologies will continue. 

## SmartOS VM tools

`imgadm`, `vmadm` are tools to manage images and VMs. They are clearly written in a way to be used as part of a cloud platform. No config files with strange syntax or super long command line options. Instead these tools work with short and clear command line commands that take JSON files as options to do the real work. This is fantastic when used as an API from a cloud orchestration layer like OpenStack. And it feels a lot more like an API than libvirt (I save the libvirt "API" rant for another time... XML snippets as arguments. Really?).

## A true cloud OS

The - at first look strange - model of usb key or PXE booting the base OS is a fantastic fit for cloud environments and makes a lot of problems go away. OS updates? Just reboot. How to install the OS? Don't. Just use a Ramdisk. Why waste space on disk when you can have a Ramdisk of 250 MB with the whole OS in it?

As you can see I'm pretty excited about SmartOS in this context. In combination with OpenStack this might be the best open source cloud orchestration stack that you can get.
