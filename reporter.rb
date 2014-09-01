require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'erb'

def credentials
  contents = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "credentials.yml"))
  erb = ERB.new(contents).result
  YAML.load(erb)
end

def stats_enabled?
  !!credentials['stathat']['enabled']
end

Dir[File.join(File.expand_path(File.dirname(__FILE__)), "lib", "*.rb")].each do |file|
  require file
end

puts NestReport.new.report
