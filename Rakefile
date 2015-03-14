task :default => :deploy


task :old_redirects => :build do
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

require 'html/proofer'

task :default => :publish

desc "Deploy to S3"
task :publish => [:build, :old_redirects] do
  sh "s3_website push"
end

task :build do
  sh "bundle exec jekyll build"
end

task :test => [:build, :old_redirects] do
  HTML::Proofer.new("./_site",
    :timeout => 15 # seconds
  ).run
end
