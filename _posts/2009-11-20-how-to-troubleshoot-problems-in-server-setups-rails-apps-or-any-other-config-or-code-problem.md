---
title: How to troubleshoot Problems in Server Setups, Rails Apps or any other Config or Code Problem
description: Generic trouble shooting tips 
layout: post
created_at: 2009-11-20 08:47:45 +0100
category: imedo
---
> This post was first published on the imedo.de devblog. The blog went offline in 2012, so I migrated the posts to my personal blog.


<p>This post might be interesting for all people who are faced with strange problems like this: "Yesterday it worked. Now it’s broken" or "It works on my machine (and it does not in production)".</p>

<p>I’m sure that all programmers and sysadmins have had an incident like this in their lives. I’ve had a lot of these problems and found out that in the end there’s always an explaination for the problem. Very rarley it’s some quantum mechaincs effect that caused the problem. In most cases there is a really simple explaination for the problem even if it was hard to find. These things include "the cause of a crashing perl script is the java version of the app starting the script", "failing tests that where caused by a minor version difference of a testing library where the error message lead to something completely different"</p>

<p>The process described below was used in all cases to find the root cause of the problem which then was solved very easily. We weren’t aware that we used this process but rather did it intuitively. After talking about the process and writing it down, we were able to find more and more problems by following these steps and also to transfer the knowledge to other people so that they will build up the intuition to find root causes of problems as well.</p>

<h3>General idea</h3>
<p>Systems that work and system that don’t work differ.</p>
<p>If you make the not working system equal to the working system, it will work.</p>
<p>That’s all there is to Troubleshooting (basically).</p>
<h3>Process to find out the difference</h3>
<p>The hard part is to find out where the working and not working systems differ.</p>
<p>The general process is really simple though:</p>
<ol>
<li>List all items that can differ</li>
<li>Check if they differ</li>
<li>Make them equal (one at a time!)</li>
<li> Repeat 3 until finished. If still broken, think harder about 1 and start again</li>
</ol>
<p>The optimized version of this is, to start with the things that are most likely to cause the problem.</p>
<p>The term "most likely" is based on</p>
<ul>
<li>your own experience</li>
<li>information found in the web: blog posts, google searches, etc.</li>
<li>experiences of your co-workers</li>
</ul>
<p>It is fundamental that you make each step conciously (writing the step/change down helps to do that). If one step doesn’t yield the desired outcome: revert it immediately. Again: having written it done helps not to forget anything. Forgetting steps may make the situation even worse.</p>

<h3>How can systems differ?</h3>
<p>The main questions are:</p>
<ul>
<li>What changed since it worked (if it is the same system)?</li>
<li>What is different or changed on the not working system compared to the working system (if it is a different system)?</li>
</ul>
<p>The latter is a lot easier because you something to compare to. In the former case you have to create the "working system" again. Which in itself may be the solution to the problem.</p>
<p>If the answer is "nothing". Think again…! Because time has progressed. So at least the time changed.</p>
<p>Possible effects of changed time</p>
<ul>
<li> File system full</li>
<li>weird time dependend behavior of applications</li>
<li>system/application restart occured</li>
<li>data changes happend</li>
</ul>
<p>Other things that may have changed:</p>
<ul>
<li>software versions through package updates – Minor Changes are important!
<ul>
<li>OS Kernel</li>
<li>OS packages</li>
<li>application libraries (ruby gems, jars))</li>
</ul>
</li>
<li>Database schemas</li>
<li>Database content</li>
<li> Filesystem content of any kind (That includes timestamps of a file that is only read!)
<ul>
<li>Location of files</li>
<li>symlink vs. real files</li>
<li>timestamps</li>
</ul>
</li>
<li> Hardware</li>
<li> Increased load
<ul>
<li>Network I/O</li>
<li>Disk I/O</li>
<li>CPU</li>
<li>Exceeded RAM -&gt; Swapping</li>
</ul>
</li>
</ul>

<p>Some things will be straightforward and it is obvious why something brakes something else. Some things are not as obvious (at least not at the time when you try to find it – it’s always obvious afterwards!). Don’t jump to conclusions about cause and effect while you debug. If you think "I’ll don’t try X because X has nothing to do with Y" try X! Maybe it has something to do with Y. You don’t know before you try. Revert (or create the equal state to the working system for) the "most obvious" things that "can’t possibly interfere with the problem". That includes</p>
<ul>
<li>Comments in Source or Configuration files</li>
<li>Whitespaces</li>
<li>Trivial Code/Configuration changes</li>
<li>minor version changes in Packages</li>
</ul>
<p>The "most likley" rule does apply here, too. Don’t start with whitespace if there are other not so subtle changes still different. Don’t look for access time timestamps if the files on one system are are in completely different locations compared to on the other system. This requires some experience but with time you’ll find which things to look for first.</p>

<h3>Tools</h3>
<ul>
<li> Filesystem-Analysis: df, ls, find,</li>
<li> Application-Behavior: strace (dtruss on Solaris and Mac OS), lsof, netstat</li>
<li> Databases: For mysql: mysql, innotop</li>
<li> Packages: Debian: apt-get, dpkg</li>
<li> Finding differences/problem causes in running vs. not running code: Binary Search (e.g. via git bisect, debugger or just plain “print”-Debugging).</li>
</ul>

<p>We hope these thoughts help you to debug and troubleshoot strange problems. Feel free to post additions, comments, tool or experiences with troubleshooting.</p>
