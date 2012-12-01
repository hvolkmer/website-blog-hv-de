---
title: Nuking a big cluster with PXE boot, DBAN and Crowbar
description: Cleaning up a test install is easy using DBAN, PXE boot and Crowbar. This post shows how to set up a cluster wide hard drive wipe
layout: post
category: OpenStack
created_at: 2012-10-05 07:53:37 +0100
--- 

When you are deploying clusters on real hardware - again and again - to test the deployment - it is quite helpful to have the hardware in a clean state. Unfortunately there is no real "Factory reset" button on hard drives. 

However, there is an simple solution to this problem: When you install your cluster using PXE boot (like when using Crowbar),  you can easily wipe all the hard drives of the whole cluster using this config.

> A word of warning at this point: The following steps describe how to DELETE data from your whole data centre (if you are not careful). So do backups, use with care, etc. You have been warned.

## Step 1: Getting DBAN

[DBAN](http://sourceforge.net/projects/dban/files/dban/) is a small custom linux boot image that has only one purpose: Delete all disks.

Download the ISO and extract the `DBAN.BZI` file.

## Step 2: Set up PXE boot

We are using this setup out of our Crowbar installation, so the PXE environment is already setup. If you use it stand alone, with Cobbler or something else, adjust the paths accordingly.

In the Crowbar case, create a file `/tftpboot/discovery/pxelinux.cfg/nuke` with the following content:

    DEFAULT nuke
    PROMPT 0
    TIMEOUT 10
    LABEL nuke
      KERNEL DBAN.BZI
      append nuke="dwipe --autonuke --method zero" silent vga=785
      IPAPPEND 2

Copy the `DBAN.BZI` file to `/tftpboot/discovery/`

## Step 3: Prepare the nuke

Since we are going to nuke anything anyway and do not want chef to interfere with our evil plans, we stop chef-client on the admin node:

    bluepill chef-client stop

Now we enable the self destruct button:

    cd /tftpboot/discovery/pxelinux.cfg/
    ln -fs nuke default

## Step 4: Nuke the cluster

To nuke the entire cluster (excluding the admin), just delete all nodes from crowbar - either by clicking through the UI or by using the crowbar CLI tool.

Then reboot the nodes via IPMI and wait for the data destruction to commence.

Nuking the admin node can be done using the DBAN iso via some virtual IPMI drive.

## Summary 

You can easily reset a lot of machines using PXE boot and DBAN. When you are using Crowbar the setup shown here makes it easy to start completely fresh any time.

Crowbar "cleans" the hard disks itself when you trigger an install, but some times this does not suffice. Some LVM parts remain intact and the following installation does not work properly. Using the DBAN nuke we can ensure that we really do start with empty hard drives on every node.

