require "bundler/gem_tasks"
require 'rake/testtask'

task :test => [:test_all]
Rake::TestTask.new(:test_all) do |t|
  t.libs << 'test'
  t.test_files = Dir.glob('test/**/*_test.rb').sort
  t.warning = true
  t.verbose = true
end
