---
title: There will be no reliable cloud (part 1)
description: Stop wasting your time trying to find one. Stop wasting your time (and money) trying to build one.
layout: post
category: OpenStack
created_at: 2013-04-03 12:45:13 +0100
---

Stop wasting your time trying to find one. Stop wasting your time (and money) trying to build one. If you find a service provider that claims that they have it: Maybe question their understanding of cloud - and business.

With all that free time, start to build reliable systems on top of unreliable clouds. 

After all these bold claims I'll convince you that this is a - some will say - sad but still valid fact of life.

The main issue here is scale. Things (very generally) work very, very different at scale. And cloud infrastructures are all about scale. Keep in mind that complexity of systems does increase exponentially and thus the things that work fine with small systems might completely fail with bigger systems.

Let's look at the different approaches to reliability that are out there and how they map to the cloud space. I start with the "building blocks" at the lowest layers and then move up to a whole cloud infrastructure (based in OpenStack) and some example services on top - because cloud for cloud's sake is a bit boring.

## High Avaiblity vs. Service resiliency

The "HA" term seems to be prevalent with current system design. You just add an "HA"-pair to your system and your safe. At least that's how vendors seem to pitch this kind of design.

There is actually [a very good presentation on the matter](http://engineering.cloudscaling.com/2013/03/service-resiliency-doesnt-always-mean-ha-or-cluster/) which goes into the differences of HA vs. resiliency by Randy Bias and Dan Sneddon of Cloudscaling.

I was in the audience at that presentation and was very excited to hear all the things that are problematic with the HA-pair-approach of doing things: HA-pairs fail in a very catastrophic way, they don't really scale (out), etc. 

And I was very disappointed to hear that the actual examples in the presentation were only about resiliency of stateless services. 

Why does this matter? Because making stateless services resilient/available is indeed not the domain of HA-pairs. It's the poster child of scale-out architectures like the Web or the internet routing backbone at layer L3. 

>> Side note: One property of resilient systems that surfaces here is the client knowledge of more than one endpoint. Think of multiple DNS entires for a domain that hosts a webpage. In the routing example this is not that obvious but if you look at IPv6 you can see multiple routing entries on the client side.

So making stateless services resilient just means: replicate all the data and serve it from multiple endpoints and let the client know about multiple endpoints. There are several possibilities on how to do that from an architectural standpoint. Choose the one you like and you're done. Easy.

The interesting part - which was left out of the presentation - is resilience of stateful services. And - while most services can actually be designed to be stateless - you have to store your data somewhere and be able to change it. Otherwise this whole information business would be kind of boring and useless.

For [stateful services](http://en.wikipedia.org/wiki/State_(computer_science) you basically have two options to make it "HA":

 - take a non-distributed base system and tuck HA on top
 - take a distributed system and make the right tradeoffs

Let's look at them in detail.

### Non-distributed base system with HA on top

This is the classic "HA" case: Take some stateful service that is not distributed in itself like NFS (which is not distributed on the server side) or MySQL add some [Pacemaker](http://www.linux-ha.org/wiki/Pacemaker) magic with some [DRBD](http://www.drbd.org/) mixed in and you're good. Or miserable.

If you look into the details, most of the time your basically cheating your way out of the [CAP theorem](http://en.wikipedia.org/wiki/CAP_theorem) by denying the existence of network partitions through a second network/heartbeat link.
Also these kinds of setups are *cause* of failures more often than not. For example several github outages were caused by these kind of HA-failures: [Github Mysql failover failure](https://github.com/blog/1261-github-availability-this-week), [Github MLAG failure](https://github.com/blog/1364-downtime-last-saturday).

"Cluster Software" causes more system outtages than hardware failures or software bugs. (See [Martin Thompson's presentation on "Event Sourced Architectures for High Availability"](http://www.infoq.com/presentations/Event-Sourced-Architectures-for-High-Availability). Around 7:30) 

Another thing to consider with the traditional approach: This approach in itself does only try to limit [MTBF](http://en.wikipedia.org/wiki/MTBF). [MTTR](http://en.wikipedia.org/wiki/Mean_time_to_recovery) can be considered but this is much harder to do as - from the system design standpoint - the expected failures of such a system are catastrophic. They are catastrophic, because a system that is not designed to be distributed and then IS distributed can never take distributed failure conditions into account and the best thing that can happen in case of failure is complete failure. You don't want the two HA-heads failing only "half". In this case one is enforced via [STONITH](http://en.wikipedia.org/wiki/STONITH) or if something goes wrong further: Failure of both heads would still be considered better than a split brain scenario.

### Distributed System and the right tradeoffs

In a distributed system the components of the system have some knowledge about the "distributed-ness" of the whole system and can therefore accommodate certain kinds of failures. Depending on the system they can actually work with partial failures (like network partitions or outtage of several different components) or handle [byzantine failures](http://en.wikipedia.org/wiki/Byzantine_fault_tolerance).

Examples of these kinds of database systems are [Percona Xtradb Cluster](http://www.percona.com/software/percona-xtradb-cluster) (MySQL with distributed backend), [Riak](http://basho.com/riak/) (distributed database where you can make CAP-tradeoffs at the request level), [Google Spanner](http://research.google.com/archive/spanner.html), [Cassandra](http://cassandra.apache.org/)

The database [Datomic](http://www.datomic.com/) is interesting in this regard. The design actually considers the state at the smallest possible level: The transaction level. You get Web-scale like Read-Scalability with stateless semantics on the read side and limited write scalability on the write side.

Btw. this is not about SQL vs. NoSQL. There are distributed versions of both "camps" available - with different tradeoffs. I won't go into detail here.

There are also block level and filesystem level systems available that are distributed form the ground up: [Ceph](http://ceph.com/), [Xtreemfs](http://xtreemfs.org), [Glusterfs](http://www.gluster.org/).

I'll cover some of the tradeoffs later, when we talk about "layers of the cloud cake".

So these two approaches are fundamentally different. While the "let's accept distributed systems as a fact" approach is harder, because you actually have to make tradeoffs. The "classic" approach tries to hide the "distributedness" of the system and abstract it away. This actually does work - at a certain scale for certain types of systems. Even up to pretty large ones - if you put in enough effort and money.


## Definition of availability / reliability?

As we move to the whole picture view of things, let's think about what availability and reliability actually mean. In the and the end user cares about the overall availability of "the system". No user actually cares about MySQL or some Webserver. They care about the service they are using. 

Also availability is not only about hardware either: It's also about software failures (See Joe Amstrong's Thesis: ["Making reliable distributed systems in the presence of software errors"](http://www.erlang.org/download/armstrong_thesis_2003.pdf) ). HA systems that need to go down for "maintenance"/software updates or fixes are a kind of a joke. They are "highly available, as long as you exclude things that would bring down availability like updates". 

Another thing to consider is the definition of availability at the different service layers: Is a service that is 2 seconds not available, still available? Is it ok, if i just don't loose a request? Or is 0.5 seconds ok, but I might drop requests.

If you think about it, you really have to do MTBF/MTTR considerations at the request/transaction level. "Is it ok, if I drop a request if no answer is there for 3ms? Try another endpoint then. If I get an answer within another 2ms, I'm fine => available" - or "I do a 'stat' system call and it's ok, to wait 2 minutes, but do not ever let that call return with a failure".

I'll get back to that picture in the "layer" discussion. But one spoiler: Most of the really highly reliable services actually solve these kinds of problems very, very high in the stack and do not care that much about reliability of the lower layers...

## We have all the ingredients, so let's build that reliable cloud!

What does this whole HA/resiliency thing have to do with a reliable (or not) cloud?

With the text so far you could come to the following conclusion:

 - A cloud infrastructure is a distributed system, it has some stateless and stateful components (I did not explicitly mention that. But just look at [this picture](http://docs.openstack.org/folsom/openstack-compute/admin/content/figures/openstack-logical-arch-folsom.jpg). If that's not distributed… I don't know what is ;-) )
 - We use the stateless approach for stateless parts (as shown in the Cloudscaling presentation)
 - We throw in some distributed data store for the stateful parts (You could use the "classic" approach for that but why bother, if there are options like distributed MySQL servers available and arguably better)
 - While were at it, put everything stateful on the VM side (e.g. base images) on a distributed datastore like Ceph, Xtreemfs or Glusterfs

We have all the ingredients, so let's build a reliable cloud, already. It cannot be that hard!

Well, if we look at the current approaches that are out there of the big cloud providers (Amazon, Google, Microsoft, HP Cloud, etc.), we can see that they follow this model only up to a point. And we can see, that this "distributed stateful part" on the backend side (in AWS terms: [EBS](http://aws.amazon.com/ebs/)) is one of the main causes for outages...

So the idea of "let's just make that part more reliable - and get rid of this insane availability zone business while were at it to use just ONE big reliable backend" somehow seems to be wrong.

I'll show you why this approach won't make sense (business and availability wise) in the next part. Feel free to comment, question and fight my thoughts and ideas. They can only get better by attacking them!

[Read part 2](http://blog.hendrikvolkmer.de/2013/04/09/there-will-be-no-reliable-cloud-part-2/)