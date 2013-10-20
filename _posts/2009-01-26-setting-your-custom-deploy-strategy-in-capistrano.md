---
title: Setting your custom deploy strategy in capistrano
description: 
layout: post
created_at: 2008-09-18 08:02:25 +0100
category: imedo
---
> This post was first published on the imedo.de devblog. The blog went offline in 2012, so I migrated the posts to my personal blog.

<p>Capistrano 2 supports custom deploy strategies. You basically just have to implement the “deploy!” and “check!” methods in your class and you’re good to go.</p>


<p>But how do you tell Capistrano to use your strategy?</p>

<p>I looked into the code and found no way of setting your strategy. So I <a href="http://github.com/hvolkmer/capistrano/commit/3c3c69332ee60ac852e8e42a54ae5e68ae48a20a">changed capistrano</a>, that it’s possible to set the strategy. When I asked <a href="http://weblog.jamisbuck.org/">Jamis Buck</a> to pull the change, he suggested that I just set the strategy directly. This approach wouldn’t need any changes to to code base.</p>

Well then we went ahead and did just that. So here’s the code for setting your custom deploy strategy (Don’t forget to require the file with your code)
<pre><code>
set :strategy, Capistrano::Deploy::Strategy::DifferentAppRootRemoteCache.new(self)
</code></pre>

<p>It works like a charm.</p>


