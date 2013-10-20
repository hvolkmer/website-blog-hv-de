---
title: Testing PDF generation
description: 
layout: post
created_at: 2008-08-06 07:59:45 +0100
category: imedo
---
> This post was first published on the imedo.de devblog. The blog went offline in 2012, so I migrated the posts to my personal blog.


<p>Generating PDFs in a Rails application is a fairly common task. Maybe you want to create a letter, report, document or maybe an invoice. Either way the stuff that normally ends up in an <span class="caps">PDF</span> is important and you want to make sure the right stuff ends up there.</p>
	
<p>This pretty much sounds like a case for automated testing. But how do you test <span class="caps">PDF</span> content? One option would be to generate the <span class="caps">PDF</span> and then create a <span class="caps">HTML</span> out of the <span class="caps">PDF</span> using <a href="http://pdftohtml.sourceforge.net/">pdftohtml</a>, parse the <span class="caps">HTML</span> and make some assertions. As you can guess, this approach isn’t very feasable, because the generated <span class="caps">HTML</span> isn’t very easy to parse.</p>

<p>Most of the time <span class="caps">PDF</span> generation in Rails applications is done using the <a onclick="javascript:pageTracker._trackPageview('/outgoing/rtex.rubyforge.org/');" href="http://rtex.rubyforge.org/">RTex</a> Plugin – the <span class="caps">PDF</span> is generated via LaTeX. This makes testing a lot easier because you can just parse and check the generated LaTeX-Source.</p>
<p>Everyone how has seen a LaTeX source file may ask: How the hell do I parse that?</p>
<p>In our case we added some “helper” comments like ”% <span class="caps">SUM BEGIN</span>” and ”% <span class="caps">SUM END</span>” before and after the part we were interested in and then used basic RegEx to parse out the interesting part. You have to manually check that the markup still looks as expected due to the newline handling of LaTeX (one is ok, two = new paragraph). Most of the time it is sufficient to look for <span class="caps">ERB</span>-Tags and use &lt; %- instead of &lt; %.</p>

<p>This approach works pretty well for us. One question which you should always keep in mind when you write tests is: What do I test on this level of testing and what do I leave out.</p>
<p>For the <span class="caps">PDF</span>/LaTeX-Testcase we choose to test the basic interaction between the objects that provide values for the <span class="caps">PDF</span> generation and the Template. We don’t test all combinations, just a few basic cases. Testing all or at least a lot of combinations, edge cases etc. is clearly a concern of unit tests.</p>
