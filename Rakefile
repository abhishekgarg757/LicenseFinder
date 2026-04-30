# frozen_string_literal: true

require 'bundler'
Bundler::GemHelper.install_tasks

require './lib/license_finder/platform'
require 'rspec/core/rake_task'

desc 'Run all specs in spec/'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.fail_on_error = true
  t.pattern = './spec/**/*_spec.rb'
  t.rspec_opts = %w[--color]
end

namespace :features do
  desc 'Run tests tagged "focus"'
  RSpec::Core::RakeTask.new(:focus) do |t|
    t.fail_on_error = true
    t.pattern = './features/**/*_spec.rb'
    opts = %w[--color --format d --tag focus]
    opts += LicenseFinder::Platform.darwin? ? [] : %w[--tag ~ios]
    t.rspec_opts = opts
  end
end

desc 'Run all specs in features/'
RSpec::Core::RakeTask.new(:features) do |t|
  t.fail_on_error = true
  t.pattern = './features/**/*_spec.rb'
  opts = %w[--color --format d]
  opts += LicenseFinder::Platform.darwin? ? [] : %w[--tag ~ios]
  t.rspec_opts = opts
end

desc 'Check for non-Ruby development dependencies.'
task :check_dependencies do
  require './lib/license_finder'
  satisfied = true
  LicenseFinder::Scanner::PACKAGE_MANAGERS.each do |package_manager|
    satisfied = false unless package_manager.new(project_path: Pathname.new('')).installed?(LicenseFinder::Logger.new(LicenseFinder::Logger::MODE_INFO))
  end
  $stdout.flush
  exit 1 unless satisfied
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
rescue LoadError
  # rubocop is a development dependency; ignore if not installed
end

task default: %i[spec features]
task spec: :check_dependencies
task features: :check_dependencies
task 'spec:focus': :check_dependencies
task 'features:focus': :check_dependencies
