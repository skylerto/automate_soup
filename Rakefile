require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :doc do
  puts `bundle exec yard --output-dir docs`
end
