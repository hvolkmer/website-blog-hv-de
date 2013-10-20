---
title: There will be no reliable cloud (part 3)
description: How I stopped worrying and love the cloud
layout: post
category: OpenStack
created_at: 2013-04-11 17:35:13 +0100
---

## How I stopped worrying and love the cloud

If you have read [part 1](http://blog.hendrikvolkmer.de/2013/04/03/there-will-be-no-reliable-cloud-part-1/) and [part 2](http://blog.hendrikvolkmer.de/2013/04/09/there-will-be-no-reliable-cloud-part-2/) you may thing all hope is lost and this cloud cannot work at all. However, there is actually a way to create fault tolerant, resilient applications on top of clouds. Actually if the application is created in a distributed, fault tolerant and resilient fashion, it will have no problem at all to run on a cloud infrastructure.

As mentioned in part 2: The main thing to get away from, when thinking about this, is the idea of "a server needs to be fault tolerant". Forget the server. It's about the end service. If your body is a few years old (which it is, if you can read this), I guess that not a single cell of your body is the same as when you where born. Yet, you are still alive. That's the kind of thinking that has to be applied to a service in a cloud setting.

## Green field cloud native apps

This behaviour is actually not that hard to achieve and there is a lot of documentation about this. There's a [AWS Whitepaper](http://d36cz9buwru1tt.cloudfront.net/AWS_Building_Fault_Tolerant_Applications.pdf) which is AWS specific but most of the ideas apply to any cloud setup. Also Netflix share a lot of their ideas and implementations of their architecture [on Sildeshare](http://www.slideshare.net/netflix) and [on github](https://github.com/Netflix/), one very recent and very good talk is this [Netflix Architecture](http://www.infoq.com/presentations/Netflix-Architecture) talk.

The main idea is actually pretty simple:

- Identify and tear apart statless and stateful parts of the application
- make the stateful parts redundant using real, distributed data stores (as mentioned in [part 1](http://blog.hendrikvolkmer.de/2013/04/03/there-will-be-no-reliable-cloud-part-1/): Riak, Cassandra, Mysql Galera, etc.)
- Make sure that the data store parts are distributed across failure domains (e.g. Availability Zones, Regions, etc.) 
- Make sure that the dependencies of your system are known to you and designed in a way that reduce the likelihood and impact of failure
- Using a [Micro-Services](http://www.infoq.com/presentations/Micro-Services) approach will help you to get these dependencies to be explicit and it let's you scale the individual parts independently as needed. You can also make the best fault behaviour decisions on a very fine granular level, so that a degraded operation and partial failure is not a big problem

>> Netflix for example uses Cassandra as their data store. That does not mean that they have one huge Cassandra cluster spanning 100s of nodes. They have 100s of Cassandra clusters with a few (about 5-50) nodes that are completely independent and each service has their own cluster (which is distributed over AZ or regions as needed)

One interesting part about the distributed data store part is that failure or hand-over of data or requests is a totally normal part of the day to day operation of the system. So adding a new node will lead to rebalancing, as would a failure of a node. A system that does these things all the time will work better than some kind of hot-standby system that will "fail-over" when something fails which maybe happen only once in a while.

While this kind of application design puts some kind of burden on the developer to deal with all these failure conditions that have been abstracted way (or to put to more realistic: ignored) through "highly available backends", the running application is the best place to decide what to do from a business logic point of view, if some kind of failure occurs. For example, if your real time web chat system does not work at the moment, you could just sent the message in an asynchronous fashion via the non-real time part of the system (IIRC Facebook does it that way). You can hardly put this kind of logic into your HA-failover scripts.

Another great talk by Michael Nygard about [Stability Anti-Patterns](http://www.infoq.com/presentations/Stability-Anti-patterns-Michael-Nygard) shows that design for failure is inevitable for the kind of environment were deploying applications in today. And this isn't even cloud specific! 

Even though complexity is not mentioned explicitly, the "reduce integration points"-message is exactly that: Reduce complexity!

>> The video also contains a fun anecdote about TCP (and how firewalls violate it). Now keep that example in mind regarding the cloud analogy of TCP vs. UDP and think about how this situation would have been different if UDP had been used and the retransmit etc. logic would have been at the application layer… 

If you want to make your application more reliable it is actually a good idea to poke it all the time and try to make it fail. This is basically what Netflix does with their chaos monkey approach. The idea behind this is [Antifragility](http://en.wikipedia.org/wiki/Antifragile:_Things_That_Gain_from_Disorder). Through the interaction of your software system with the developers and the feedback you get from failures, you can basically turn the complex system that consists only of the software application into a [complex adaptive system](http://en.wikipedia.org/wiki/Complex_adaptive_system) (consisting of the running(!) software and the interactions of the users and operators), that can respond to change and become more resilient.

## Other benefits of apps in the cloud that help with reliability

.. and don't need any special reliable backend. Using a cloud setup you can basically test and deploy in ways that are not - easily - possible in a traditional world (like [Blue/Green Deployment](http://martinfowler.com/bliki/BlueGreenDeployment.html)), spinning up 100s or 1000s of instances to do load and failure testing. And you can do that with up to 100% of the same environment (architecturewise, operating system, number of services etc.) as production.

## But I have a legacy system and want to put it into the cloud

The main thing to remember is not to confuse "cloud instance" with "server". So if you need to roll your classic HA-DB Setup in the cloud, do not put it in one Avaibility zone on two instances. Use to zones that are guaranteed to be independent. 

There is actually a good overview - although very old school in nature (Who would have thought - it's from Oracle!) - [Mysql Reference Architectures](http://www.infoq.com/news/2013/03/MySQL-Reference-Architectures) if you choose the failure domains as communicated by the cloud provider there should not be a big problem really.

If your cloud provider (or internal cloud) cannot do that, you can still plan to reduce your MTTR. This is a very good idea anyway! I'm always surprised how little thought seems to be put into reducing MTTR. "We have a HA system, so we're good". No! Think about what happens after failure and about the impact! You cannot predict the probabilities but you can predict impact of failures pretty well!

Of course you can [split up workloads in different cloud environments](http://gigaom.com/2013/01/14/resiliency-and-reliability-the-devil-is-in-the-detail/) - latency might become a problem. So YMMV.

Another problem with non cloud-native apps that run on more than one server at some point most of them use something like NFS as a shared file-based datastore. Of course you can run NFS on some cloud instance, but then NFS itself is not really distributed and prone to catastrophic failure. Also, the filesystem abstraction is really broken over the network. You might get away with it, if you know and control the network itself. In a large scale cloud network... Not the best idea (failure semantics for file systems are really very different than network protocols...).

So if you want to run this kind of applications in the cloud, you have to think about the tradeoffs: Maybe you don't really need a shared-filesystem backend. Maybe you can easily change the application to use HTTP-based Object-Storage. Or you could run some distributed NFS-like replacement such as GlusterFS or xtreemfs on top of cloud infrastructure (again: use more then one zone). As always: it depends.

## Further reading:

- [Good overview of a modern web app approach](http://www.12factor.net/)
- [Lot's of good talks](http://infoq.com) - Look around a bit, almost every relevant topic is covered
- [Technical talks by Netflix](http://www.slideshare.net/netflix)
- [Complex vs. Simple Storage systems](http://radar.oreilly.com/2012/04/complexity-vs-simplicity.html)
- Antifragility (Read and understand it)
- [Agile Theory](http://www.infoq.com/presentations/Agile-Theory) - Although the title is "agile", it's really about complexity


## Closing thoughts

This is certainly not all I have to say about this topic (expect more posts ...), but instead of collecting more and more links and ideas, I wanted to get this out there to fuel the discussion about these ideas. I think "the cloud" as in "compute infrastructure" is mostly still misunderstood. It seems to be something we have had for a long time. It's "just VMs in the internet behind an API" or "Virtualization 2.0". It's not. It's so much more! It's different. If you think differently about some things...