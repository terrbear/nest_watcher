require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'erb'

def credentials
  contents = File.read(File.join(File.dirname(__FILE__), "credentials.yml"))
  erb = ERB.new(contents).result
  YAML.load(erb)
end

Dir[File.join(File.dirname(__FILE__), "lib", "*.rb")].each do |file|
  require file
end

puts NestReport.new.report
