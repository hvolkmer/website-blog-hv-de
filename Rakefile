task :default => :deploy


task :old_redirects => :generate do
  require 'fileutils'
  Dir.chdir("_site/") do 
    # /page2/ -> /2/
    Dir.glob("page*") do |pagination|
      FileUtils.cp_r pagination, pagination.gsub("page","")
    end

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

task :generate do
  sh "jekyll"
end

desc "deploy"
task :deploy => [:generate, :old_redirects] do 
  sh "s3cmd sync _site/* s3://blog.hendrikvolkmer.de"
end
