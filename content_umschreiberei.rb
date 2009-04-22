require 'yaml'

Dir.glob("content/**/**").select { |m| m =~ /[0-9].*\/index.txt/ }.each do |file_name|
#  file_name = 'content/blog/2008/09/09/longtime-value-of-tests/index.txt'
  content = File.read(file_name)
  head, config, site_content = content.split("---")
  y_config = YAML.load(config)
#  y_config["sections"] = y_config["sections"].split(" ") if y_config["sections"] && y_config["sections"].is_a?(String)
#  y_config["tags"] = y_config["tags"].split(" ") if y_config["tags"] && y_config["tags"].is_a?(String)
#  y_config.merge!("created_at" => "#{file_name.split("/")[2..4].join("-")} 13:09:47.526917 +02:00")
  y_config["layout"] = "post"

  File.open(file_name, "w") do |f|
    f.puts YAML.dump(y_config)
    f.puts "---"
    f.puts site_content
  end
end

