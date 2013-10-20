---
title: Migrating from Active Messaging to Resque with zero code changes using background_lite
layout: post
created_at: 2010-08-23 07:21:10 +0100
category: imedo
---
> This post was first published on the imedo.de devblog. The blog went offline in 2012, so I migrated the posts to my personal blog.

<p>Most people ask us why we use <a  href="http://github.com/imedo/background_lite">background_lite</a> at all, as it doesn’t provide any background job functions itself. Why do you use ActiveRecord and not plain SQL? Abstraction? Exactly!</p>
<p>The goal of background_lite is to abstract the interface of background handling and let you configure the actual background layer. We’ve been using <a href="http://code.google.com/p/activemessaging/wiki/ActiveMessaging">active_messaging</a> for background jobs since we use background jobs (mid 2007). And we soon felt that the way we had to use its API was kind of obtrusive. So we created background and later background_lite as an abstraction layer for background jobs.</p>
<p><a href="http://code.google.com/p/activemessaging/wiki/ActiveMessaging">active_messaging</a> was quite convenient to use but there were several things that we didn’t like about it:</p>
<ul>
<li>The backend we use (ActiveMQ) is Java – This is not a Java-bashing reason. The problem with Java infrastructure (for us) is that monitoring and starting/stopping processes isn’t the same as all the other infrastructure we use</li>
<li>ActiveMessaging pollers aren’t easy to monitor/start/restart – They should be if you look at the code. But we never got them to start/restart as we wanted them to</li>
<li>ActiveMQ showed some strange behaviour: Polling the queue started to fail for no apparent reason from time to time and so did pushing stuff into the queue. Restarting ActiveMQ helped sometimes but not always. And it resulted in a corrupted “data” directory which means lost jobs. Recovering from this situation also required restarting our Mongrels (which is rather strange).</li>
</ul>

<p>As <a href="http://github.com/">github</a> is successfully using <a  href="http://github.com/defunkt/resque">Resque</a> we tried it on a side project via background_lite and found that it works really well. The reasons to chose Resque (and not some other queuing solution) are pretty much the same as <a  href="http://github.com/blog/542-introducing-resque">described by the github guys</a>.</p>
<p>As the other project already used Resque via background_lite the required&nbsp;<a href="http://github.com/imedo/background_lite/commit/f7033bdaeee31ae200193f987f47b62e7caf3ded">handler for Resque</a> was already in place. So&nbsp;<strong>the only thing we needed to do to switch from active_messaging to Resque </strong>(besides the installation of Resque itself) <strong>was to change a simple configuration option!</strong></p>
<p>We’re talking about changing a major piece of backend infrastructure. The transition went flawlessly (not a single lost job or application error) and since the switch <strong>one day</strong> ago <strong>Resque already has processed more than 2 million requests without a single hiccup.</strong></p>

<p>Further information:</p>
<ul>
<li><a href="http://code.google.com/p/activemessaging/wiki/ActiveMessaging">active_messaging</a></li>
<li><a href="http://github.com/imedo/background_lite">background_lite</a></li>
<li><a href="http://github.com/imedo/background_lite"></a><a  href="http://github.com/defunkt/resque">Resque</a></li>
<li><a href="http://github.com/blog/542-introducing-resque">Reasons for Resque</a></li>
</ul>
