---
title: Things to OmniFocus
description: How to migrate your tasks and projects from Things to OmniFocus
layout: post
created_at: 2012-11-07 08:37:13 +0100
---

I've been using [Things][things] for about three years now and it's great. After re-reading [GTD][gtd] a few weeks ago I realised why the system is not working for me as good as it used to: 

1. Things does not have the concept of "Contexts". It has "Tags" that you can use to simulate them but it does not feel the same
2. No folder structure to organise projects - only a flat list. This is fine for a few projects but if you have dozens it is hard to keep track of them. This makes reviews harder and thus I'm more likely to skip them.

[Omnifocus][of] can organise task and projects exactly the way I want so I gave it a try. The Omnifocus sync options are more flexible, too.

Of course I wanted to import my tasks and projects from Things. This turned out to be a bigger problem than I thought it would be.

If you are trying to do the same, here is my solution for Omnifocus 1.10.4 and Things 2.1. This is not ideal and has some drawbacks but it works for the most important stuff: Getting your tasks and projects over to Omnifocus.

1. In Things, move all your projects from "Someday" it active. We will only import active projects.
2. Start Things and Omnifocus
2. Use [this AppleScript][importscript] to copy over the projects and tasks. To use the Script just start "AppleScript Editor" and copy/paste the code in the editor, hit "compile" and then "run"
3. Wait while the tasks and projects are being copied over
4. Sort your projects in Omnifocus (e.g. mark "Someday" projects as "on hold")

I'm sure step 5 could be automated using AppleScript somehow. However it was not worth the effort for me. I just went trough the projects and marked them accordingly.

Also, the Things "Logbook" is not imported at the moment, so all your completed tasks are still in Things. 


[things]: https://culturedcode.com/things/
[of]: http://www.omnigroup.com/products/omnifocus/
[gtd]: http://www.amazon.com/Getting-Things-Done-Stress-Free-Productivity/dp/0142000280/ref=sr_1_1?ie=UTF8&tag=hendrvolkm-21
[importscript]: https://gist.github.com/4020468