---
title: The fear of OpenStack fragmentation and the holy grail of cloud
description: To fight fragmentation the OpenStack foundation - not vendors - needs to step up and provide an interop certification framework
layout: post
---
Last week I was at the OpenStack Grizzly Summit and one thing was clear from the beginning: OpenStack generates a lot of interest in all kinds of businesses: Hosting, Enterprise IT, Development shops. All kinds of people want to use cloud infrastructure in one way or another to get the benefits of a more flexible infrastructure.

At the Folsom Summit in April a lot of talk was about "What is OpenStack?". A Distribution? A cloud operating system? A Framework. It seems to me that the consesus now is "its a toolkit to build cloud infrastructures".

I agree. This is fairly accurate and reflects the way most people use it. There are several cloud products out there that use OpenStack in different ways to solve their problems. It also shows that it's not an off the shelf product that you just buy right now. 

When people say "OpenStack is not mature", it's like saying "The iPhone SDK is not mature". Well, it is not a product. So this assessment basically does not make sense. It is something that you use to _create_ a product.

At this point it is unclear in what direction OpenStack will evolve. Certainly people use it to create products or services with it. And I can see that this creates a fear of fragmentation. A fear that was prominently put out by Gartner and rebutted by several OpenStack thought leaders.

Saying that this will not happen is not enough, though. It will happen if we do not actively fight it. That's life. This is how the world works. Things decay. Entropy.

Why is this important anyway? OpenStack is and will stay OpenSource it will be developed further, it will get better.

It might get better. Without a clear definition or goal of what OpenStack will provide and what it will not provide, it might end up being what it is now: a toolkit. Everybody picks their tool from it and creates a frankencloud.

Why is that bad? It solves your IT problem, right? Indeed it does for you, right now. And then, after the successful internal OpenStack deployment project your CIO proclaims "We're going hybrid!" And you realise that just by using OpenStack internally does not make it compatible with the public Cloud offerings that are out there that use OpenStack as well.

And this is not an API issue. Just because OpenStack has EC2 APIs does not make OpenStack compatible with EC2. There is more needed to compatibility than just an API. The API is necessary but not sufficient.

This is the holy grail of the cloud: Cloud interoperability. 

I think it can be done. But it has to be actively developed. This kind of stuff is hard and it does not "happen". At the analyst panel at the grizzly summit Steve O'Grady of Red Monk shared this view. He compared it with Java/J2EE: You can write once and run anywhere with Java - up to a point.

"100% no modifications needed"-portability between cloud service providers internal/external clouds will not be possible in every case. But: It _is_ possible up to a certain point and this point should be the goal.

How can we achieve this? OpenStack needs an executable Test Suite that everybody can run. Similar to the [Java TCK](http://en.wikipedia.org/wiki/Technology_Compatibility_Kit) just without the licensing issues. The OpenStack Foundation should make this kind of thing officially available. From a technical standpoint there already is code that could be a starting point ([Tempest Project](https://github.com/openstack/tempest)).

It should be clear that if your internal cloud deployment passes this test suite and your service provider does also pass it, you should have no problems to deploy your application on the public provider.

[Rackspace already is starting to create something like this](http://www.rackspace.com/blog/rackspace-private-cloud-certification-program-combines-product-innovation-and-enterprise-stability/). While it might make business sense for them to do so, I think this approach is wrong. This kind of offering has to come from the OpenStack foundation! Nobody (except Rackspace) wants a "Rackspace compatible" cloud. 

Troy Toman from Rackspace said: "We have a core that we know is the right thing. So how do we continue to innovate?". By putting the certification process into the OpenStack Foundation instead of Rackspace as a company.

For true cloud interop we need a vendor and service provider independent entity - the OpenStack Foundation - that defines what is needed for your cloud service or private cloud product to call it "OpenStack compatible".

Everybody goes ahead and creates their own little or large OpenStack cloud and solves problems. This is fine but if we really want to make the best use of the possibilities of cloud computing with OpenStack in the next years a lot of work has to be done to make cloud interop happen.

This work can either happen at every IT shop that wants to deploy cloud services in a hybrid model - or - at a central point that already manages OpenStack related things: the OpenStack Foundation.

The latter would be much more effective and would end up costing everybody less. It also would be much more in alignment with how the cloud model works than the "everybody does their own" model.

There was a comment at the summit that [OpenStack can tell what Amazon has to do](http://www.networkworld.com/news/2012/101712-openstack-amazon-263461.html) and at this point it was certainly [arrogant](https://twitter.com/justinsheehy/status/259015836495409152) to says so. With a cloud behaviour defining test suite and a strong statement from the OpenStack Foundation that proclaims that "This is how clouds behave" Amazon's cloud might just behave the same way. And then this is not an arrogant statement anymore but just reality.

Cloud interoperability is essential to the success of OpenStack in my opinion. This is certainly not the last post on that topic. 