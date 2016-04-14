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

namespace :gem do
  task :build do
    system("gem build reflect.gemspec")
  end

  task :install => :build do
    require File.expand_path('../lib/reflect/version', __FILE__)
    system("gem install reflect-#{Reflect::VERSION}.gem")
  end

  task :publish => :build do
    require File.expand_path('../lib/reflect/version', __FILE__)
    system("gem push reflect-#{Reflect::VERSION}.gem")
  end
end
