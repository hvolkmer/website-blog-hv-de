---
title: Moving from Wordpress on a VPS to Jekyll and Amazon S3
description: How and why to move your blog from Wordpress to a static webpage that is hosted on Amazon S3 using the new website hosting feature
layout: post
created_at: 2011-02-25 13:19:35 +0100
---

## What and Why?

This blog has gone through a lot of migrations: From [Movable Type](http://www.movabletype.org/) to [Wordpress](http://wordpress.org/) (several version updates) to [Mephisto](https://github.com/technoweenie/mephisto) to [Webby](http://webby.rubyforge.org/) and finally to [Jekyll](http://github.com/mojombo/jekyll).

[My other blog](http://www.wenigeristweniger.de) was set up using [Wordpress](http://wordpress.org) from the beginning and moved to [Jekyll](http://github.com/mojombo/jekyll) recently as well.

Why did I do this? Do I hate Worpress or do I care that it's written in PHP? Not at all. I could care less which programming language is used to serve a page even if I don't particularliy like the language.

The main reason for the switch was really that I don't need most of the features that Wordpress offers and I like the idea of pure static web pages (for stuff that is - at its core, well, ... static). When [Amazon announced its new web hosting support for S3](http://www.allthingsdistributed.com/2011/02/website_amazon_s3.html), I noticed that I didn't really need a VPS to run the few pages that I have and decided to cancel my VPS subscription and put everything on S3.

## How?

### Wordpress to Jekyll

To migrate from Wordpress to Jekyll, I basically followed [Paul Stamatiou's How to](http://paulstamatiou.com/how-to-wordpress-to-jekyll). He does some special stuff. If you'd like to see the minimal migration, here it is:

Get your Wordpress articles:

    $ wget --no-check-certificate https://github.com/mojombo/jekyll/raw/master/lib/jekyll/migrators/wordpress.rb
    $ ruby -r "wordpress" -e 'Jekyll::Wordpress.process("your_wordpress_db", "wp_user", "secretwp_pwd")'

If you happen to have a lot of drafts, edit the wordpress.rb file. Change the SQL from "= 'published'" to "<> 'published'" and change the output folder from "\_posts" to "\_drafts". Then run the command again to export your drafts.

Now copy the "\_posts" folder to your Jekyll folder. As recommended by the Jekyll author, you can just clone his repo, remove the copyrighted stuff and put your posts folder in. I like to have a clean git repo to start with, so also deleted the .git folder.

    $ git clone https://github.com/mojombo/tpw.git
    $ rm -rf .git _posts images
    $ cp -r your_wordpress_dump_directory/_posts _posts

You can now try to run jekyll and see how it looks like:

    $ jekyll --auto --server

And go to http://localhost:4000. Change CSS and HTML templates as necessary.

Now for the S3 part. I just added a Rakefile with the following task to my repository:

    task :default => :deploy

    desc "Deploy to S3"
    task :deploy do
      sh "jekyll"
      sh "s3cmd sync _site/* s3://blog.hendrikvolkmer.de/"
    end

You need to install s3cmd from [s3tools](http://s3tools.org/) for it to work. If you're using a Mac you can use Macports:

    $ sudo port install s3tools

The S3 setup is rather simple as well. Just set up a bucket with the name of your Domain (including subdomain), activate the webhosting inside the  "Website configuration" tab of "Properties"

    {
     "Version":"2008-10-17",
     "Statement":[{
         "Sid":"PublicReadForGetBucketObjects",
         "Effect":"Allow",
           "Principal": {
            "AWS": "*"
          },
       "Action":["s3:GetObject"],
       "Resource":["arn:aws:s3:::blog.hendrikvolkmer.de/*"
       ]
      }
     ]
    } 

Change the Domain to your bucket name which is your domain name. You then have to point your DNS record of your domain to the Amazon S3 name of your bucket (e.g. blog.hendrikvolkmer.de.s3-website-eu-west-1.amazonaws.com CNAME blog.hendrikvolkmer.de).

You can then deploy your newly created static website using:

    $ rake

Check out the [S3 Website Hosting documentation](http://docs.amazonwebservices.com/AmazonS3/latest/dev/HostingWebsiteQS1.html) for further information.

### Webby to Jekyll

The process from webby to Jekyll straightfoward as both systems are static web page generators. You might wonder, why to migrate at all. Webby really is a static web page generator. It has support for blog posts but it feels like it is put on top and just isn't integrated that well. Jekyll in the other hand was designed for blogs. I also like the idea of liquid templates better than plain ERB. Both Webby and Jekyll support Textile and both use [YAML Front Matter](https://github.com/mojombo/jekyll/wiki/yaml-front-matter).

The standard webby blog page structure can be migrated to Jekyll posts using the following command:

    find content/????/*/* -name index.txt | 
    while read file
    do 
      mv $file _posts/$(echo $file | sed -e 's/content\///' -e 's/\//-/g' -e 's/-index.txt/.textile/' )
    done

## Bonus: SEO tricks - or just being a good web citizen

### URLs

The [W3 recommends that you design your URLs in a way that they don't change](http://www.w3.org/Provider/Style/URI) - or at least redirect to the new URL. That is generally a good idea and also has some benefits for [SEO](http://en.wikipedia.org/wiki/Search_engine_optimization).

S3 doesn't support redirects (as far as I know). So my solution is this: I create pages via Jekyll, copy the pages to the "old" folder structure and use the [canonical tag](http://googlewebmastercentral.blogspot.com/2009/02/specify-your-canonical.html) to direct search engines to the new URL.

I use this for date URLs in blogs (e.g. /2011/3/3/foo -> /2011/03/03/foo) and for pagination (see below). Some how every blog system has a different default regarding date URLs... I once forgot to change them and now I'm stuck with both URL schemes. [Murphy's law](http://en.wikipedia.org/wiki/Murphy's_law) mandates that you basically receive no incoming liks execpt directly before and after you change your URL schema, so that you have to support both forever. That's what happened to me ;-)

I use the following code to generate the additional pages:

    task :old_redirects => :generate do
      require 'fileutils'
      Dir.chdir("_site/") do 

      # Redirect 2009/2/3/foo to 2009/02/03/ by copying the destination file
      # Canonical tag takes care of the rest
      Dir.glob("200?") do |year|
        Dir.chdir(year) do
          Dir.glob("0*") do |month|
            Dir.chdir(month) do
              Dir.glob("0*") do |day|
                FileUtils.cp_r day, day.gsub("0","")
              end
            end
            FileUtils.cp_r month, month.gsub("0","")
          end
        end
      end
    end
    end

In my layout I use this go generate the canonical tag:

    <link rel="canonical" href="http://blog.hendrikvolkmer.de(( page.url | canonical_url ))" /> 

(Use the standard liquid curly braces instead of parentheses in your code. Apparently [it is impossible to escape liquid templates](http://tesoriere.com/2010/08/25/liquid-code-in-a-liquid-template-with-jekyll/)). See filter implementation and reason for it below.

### Pagination

To paginate the index page I used [this gist](https://gist.github.com/227621). Somehow pagination seems to be not that common among Jekyll users. I didn't find that much information.

The paginator generates URLs like this "/page2/", "/page3/" whereas my old structure was just "/2/","/3/" etc. To make both work I used the same idea as above (in a rake task):

    # Inside Dir.chdir("_site") block
    Dir.glob("page*") do |pagination|
      FileUtils.cp_r pagination, pagination.gsub("page","")
    end

Jekyll then generates "http://blog.hendrikvolkmer.de/page2/index.html" as "page.url" which I found ugly. So I added the "canonical_url" filter by creating "_plugins/canonical.rb" with the following content:

    module CanonicalFilter

      def canonical_url(arg)
        arg.gsub("/index.html","") 
      end
    end

    Liquid::Template.register_filter(CanonicalFilter)

Send comments to [@hvolkmer](http://www.twitter.com/hvolkmer)

