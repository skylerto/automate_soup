require "bundler/setup"
require "automate_soup"
require 'byebug'
require 'simplecov'
# Dir["lib/**/*.rb"].each {|file| puts file; puts load(file); }

SimpleCov.start do
  coverage_dir 'docs/coverage'
  add_filter '/spec/'
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
