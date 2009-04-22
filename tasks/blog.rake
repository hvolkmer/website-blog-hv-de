Loquacious.configuration_for(:webby) {
  desc "The default directory where new blog posts will be created."
  blog_dir 'blog'
}

namespace :blog do

  # iterate over all the files in the "templates/blog" folder and create a
  # rake task corresponding to each file found
  FileList["#{Webby.site.template_dir}/blog/*"].each do |template|
    next unless test(?f, template)
    name = template.pathmap('%n')
    next if name =~ %r/^(month|year)$/  # skip month/year blog entries

    desc "Create a new blog #{name}"
    task name => [:create_year_index, :create_month_index] do |t|
      page, title, dir = Webby::Builder.new_page_info

      # if no directory was given use the default blog directory (underneath
      # the content directory)
      dir = Webby.site.blog_dir if dir.empty?
      dir = File.join(dir, Time.now.strftime('%Y/%m/%d'))

      page = File.join(dir, File.basename(page))
      page = Webby::Builder.create(page, :from => template,
                 :locals => {:title => title, :directory => dir})
      Webby.exec_editor(page)
    end
  end  # each

  # this task is used to create the year index file (blog/2008/index.txt)
  task :create_year_index do |t|
    # parse out information about the page to create
    _, _, dir = Webby::Builder.new_page_info
    base_dir = "."
    
    #year = Time.now.strftime '%Y'
    Dir.glob(File.join('content','????')).each do |year_path|
      year = year_path.split("/").last
      # if no directory was given use the default blog directory (underneath
      # the content directory)
    
      #      dir = Webby.site.blog_dir if dir.empty?
      dir = File.join(base_dir, year)

      # determine the filename and template name
      fn = File.join(dir, 'index.txt')
      tmpl = Dir.glob(File.join(Webby.site.template_dir, 'blog/year.*')).first.to_s

      delete_if_exists File.join(Webby.site.content_dir, fn)
      if test(?f, tmpl) # and not test(?f, File.join(Webby.site.content_dir, fn))
        Webby::Builder.create(fn, :from => tmpl,
            :locals => {:title => year, :directory => dir})
      end
    end
  end

  def delete_if_exists(file)
   if test(?f, file)
      FileUtils.rm file
    end
  end

  # this task is used to create the month index file (blog/2008/04/index.txt)
  task :create_month_index do |t|
    # parse out information about the page to create
    _, _, dir = Webby::Builder.new_page_info
    base_dir = "."
    
    now = Time.now
    month = now.strftime '%m'
    Dir.glob(File.join('content','????',"*")).each do |year_and_month_path|
      base, year, month = year_and_month_path.split("/")
      # if no directory was given use the default blog directory (underneath
      # the content directory)
      dir = Webby.site.blog_dir if dir.empty?
      dir = File.join(base_dir, year, month)

      # determine the filename and template name
      fn = File.join(dir, 'index.txt')
      tmpl = Dir.glob(File.join(Webby.site.template_dir, 'blog/month.*')).first.to_s
      
      delete_if_exists File.join(Webby.site.content_dir, fn)
      if test(?f, tmpl) # and not test(?f, File.join(Webby.site.content_dir, fn))
        Webby::Builder.create(fn, :from => tmpl,
            :locals => {:title => month, :directory => dir})
      end
    end
  end
  
  
  # this task is used to create the year index file (blog/category_name/index.txt)
  task :create_category_index do |t|
    _, _, dir = Webby::Builder.new_page_info
    dir = "."
    ::Webby.load_files
    articles = Webby::Resources.pages
    sections = []
    tags = []
    articles.each do |article| 
     sections << article.sections if article.sections
     tags << article.tags if article.tags
    end

    categories = sections.flatten.uniq
    tags = tags.flatten.uniq

    create_dirs_for(categories, dir + "/category", :category)
    create_dirs_for(tags, dir + "/tags", :tag)

  end

  def create_dirs_for(categories, dir, type)
    categories.each do |category|
      cat_dir = File.join(dir.to_s, category.to_s)
      # determine the filename and template name
      fn = File.join(cat_dir, 'index.txt')
      tmpl = Dir.glob(File.join(Webby.site.template_dir, "blog/#{type.to_s}.*")).first.to_s

      if test(?f, tmpl) and not test(?f, File.join(Webby.site.content_dir, fn))
          Webby::Builder.create(fn, :from => tmpl,
              :locals => {:title => category, :directory => cat_dir, type => category})
        feed_tmpl = File.join(Webby.site.template_dir, "blog/#{type.to_s}_feed.erb")
        old_mode = Webby.site.create_mode
        Webby.site.create_mode = 'file'
        if test(?f, feed_tmpl)
          Webby::Builder.create(File.join(cat_dir, 'feed.txt'), :from => feed_tmpl,
                  :locals => {:category => category})
        end
        Webby.site.create_mode = old_mode
      end
    end
  end

end  # namespace :blog

# EOF
