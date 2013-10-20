---
title: Using Rails engines with JRuby and glassfish
description: 
layout: post
created_at: 2008-09-18 08:02:25 +0100
---
> This post was first published on the imedo.de devblog. The blog went offline in 2012, so I migrated the posts to my personal blog.

<p>If you try to deploy your Rails app which is using <a href="http://rails-engines.org/">Rails Engines</a> with <a href="http://jruby.codehaus.org/">JRuby</a> in an Java application server, you end up with errors on the first request. Basically JRuby is complaining that it cannot create directories. This is due to the fact that engines tries to copy over assets from the plugins into the public dir of the rails app.</p>

<p>In an application server the rails directory structure is "turned inside out" as <a href="http://blog.nicksieger.com/">Nick Sieger</a> calls it. So the public directory is actually inside the base dir of the deployed app and the class files are in the WEB-INF dir.</p>

<p>You can easily fix that if you put the following code right after your engines require in your environment.rb (or inside an initializer file):</p>

<pre><code>
if Object.const_defined?("PUBLIC_ROOT")
  Engines.public_directory = PUBLIC_ROOT
end
</code></pre>

<p><span class="caps">PUBLIC</span>_ROOT is defined inside JRuby (or warble) and set to the correct path by warble.</p>

<p>I found out about this behavouir in the Rails Tutorial Session <a href="http://en.oreilly.com/railseurope2008/public/schedule/detail/3598">Take the Jruby Challenge: Deploy Your Rails Application With JRuby and Taste the Difference</a>  with the helping hand of <a href="http://blog.nicksieger.com/">Nick Sieger</a></p>
