task :default => :deploy

task :old_redirects => :generate do
 sh "for DIR in _site/page*; do cp -a $DIR $(echo $DIR | sed -e 's/page//'); done"
end

task :generate do
  sh "jekyll"
end

desc "deploy"
task :deploy => [:generate, :old_redirects] do 
  sh "s3cmd sync _site/* s3://blog.hendrikvolkmer.de"
end
