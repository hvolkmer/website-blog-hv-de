---
title: Status of the SmartOS OpenStack Port
description: Update on the current status of the SmartOS port
layout: post
--- 

Since the first blog post about the SmartOS port and after my lightning talk at the Grizzly Summit, several people have asked me about the status of the port. So here's an update.

## Current status

First announcement: It is not production ready. That's not because the code is bad or unstable. It is just incomplete at the moment. The whole network management code is still missing. 

The whole thing is not a part of core OpenStack. I'm not sure if it ever will be, but that's not really a problem. The code should be easily pluggable to the current OpenStack code base. If the code is good enough and sufficiently complete I do not see why it should not be part of the core project. With my current understanding of the code organisation this would mean the code would be merged to the nova code tree. If - for some reason - it will not be accepted, it should be easily be distributable as a separate python egg.

## Future plans

Several people asked me why I'm doing this. Who is behind this etc. Well, it's currently just a hobby project out of curiosity.  I've been following the Solaris/OpenSolaris/Illumos/ development for some time because I think they have some pretty cool and different solutions to problems (ZFS, dtrace, etc.).

Besides my hobby projects I do have work to do, so the development progress on this project will be not predictable. If you are interested in the further development, just watch this blog or the wiki page mentioned below.

## More information

Andy Edmonds one of the original creators of the [Blueprint][bp] created a [SmartOS wiki page at the OpenStack wiki][wiki]. I added some info to it - including the current code base and information about how to set up a SmartOS/OpenStack installation.

[wiki]: http://wiki.openstack.org/smartos
[bp]: https://blueprints.launchpad.net/nova/+spec/smartos-support