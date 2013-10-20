---
title: Two years of git – a retrospective
layout: post
created_at: 2010-11-08 09:29:29 +0100
category: imedo
---

> This post was first published on the imedo.de devblog. The blog went offline in 2012, so I migrated the posts to my personal blog.

<p>We started using git in late 2008 mainly not because it was cool but because it solved one particiular problem: Slow deployment.</p>
<p>To understand this you have to know that our codebase was rather big and monolithic back then. One big rails project with a lot of small files and lots of plugins. This meant we had about 3 times as much files to deploy (3 files per file in every directory in the .svn-directory) using capistrano which bascially does a checkout for a new deploy.</p>
<p>This process took about 45 minutes in the end (yes, 45 minutes!) which was not acceptable. We could have thought about other solutions but as there were other advantages to git we switched to git and the deployment process went back to about 2 minutes.</p>
<p>Over the last two years we tried different models and workflows and ended up with what many people consider the standard workflow for git:</p>
<ul>
<li><strong>master</strong> is the master branch and main development branch, CI runs off master</li>
<li>We create <strong>feature branches</strong> and local "try and experiment" branches but they normally live no longer than a few days and are constantly rebased to master.</li>
<li>If all tests in our continuous integration environment succeed, the code will automatically be merged into a branch called “<strong>live</strong>“. We deploy only from “<strong>live</strong>” and can therefore deploy at any time knowing that all tests have been run on the code we are deploying</li>
</ul>
<p>A few things we learned:</p>
<ul>
<li>never rebase remote branches – I think you can do it right somehow but if you don’t it will blow up your repository</li>
<li>Changing history is ok – locally – never amend or rebase – a commit that has been published – or: don’t use git push -f</li>
<li>git bisect is fantastic to find code breaking commits (running tests for each bisected commit) or in specific code changes (using grep &lt;change&gt;) e.g. “Which commit did remove of some word in copy on a website”</li>
<li>git is fast – most of the time</li>
<li>Developing a certain discipline regarding branching is very important. Branches are useful for certain things, but a lot of long lived, diverging branches is certainly a smell</li>
<li>The ability to split and merge repositories without losing history is very useful (some information will get lost, when splitting and then remerging the same repo, but we never did that anyways)</li>
<li>The git index/additional step required when commiting is rather annoying at first but no one wants to live without it after a while</li>
<li>Local branches, commit –amend and rebase -i allow us to re-fit the commits into logical chunks which aren’t always apparent at first when developing a new feature. This is really useful if a commit is reviewed in the future</li>
<li>Having all commits available on every developer machine is very useful for speed, offline-development and backup reasons</li>
</ul>
<p>What could be better? What’s missing? We thought about that last week and didn’t come up with anything. Git seems to be a rather perfect SCM – at least for us at the moment.</p>
