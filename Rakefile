task :environment do
  require File.expand_path('../lib/reflect', __FILE__)
end

task :irb => :environment do
  require 'irb'
  ARGV.clear
  IRB.start
end

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
end

namespace :test do
  task :all => [:integration, :test]
end
