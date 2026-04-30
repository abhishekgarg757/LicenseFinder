# frozen_string_literal: true

version = File.read(File.expand_path('VERSION', __dir__)).strip

Gem::Specification.new do |s|
  s.required_ruby_version = '>= 3.1.0'
  s.name        = 'license_finder'
  s.version     = version

  s.authors = ['Abhishek Garg']
  s.email   = ['abhishekgarg757@users.noreply.github.com']
  s.homepage = 'https://github.com/abhishekgarg757/licensefinder'
  s.summary  = "Audit the OSS licenses of your application's dependencies."

  s.description = <<-DESCRIPTION
    LicenseFinder works with your package managers to find
    dependencies, detect the licenses of the packages in them, compare
    those licenses against a user-defined list of permitted licenses,
    and give you an actionable exception report.
  DESCRIPTION

  s.license = 'MIT'

  s.metadata = {
    'bug_tracker_uri'   => 'https://github.com/abhishekgarg757/licensefinder/issues',
    'changelog_uri'     => 'https://github.com/abhishekgarg757/licensefinder/blob/main/CHANGELOG.md',
    'documentation_uri' => 'https://github.com/abhishekgarg757/licensefinder/blob/main/README.md',
    'homepage_uri'      => 'https://github.com/abhishekgarg757/licensefinder',
    'source_code_uri'   => 'https://github.com/abhishekgarg757/licensefinder',
    'rubygems_mfa_required' => 'true'
  }

  s.add_dependency 'bundler'
  s.add_dependency 'csv', '~> 3.3'
  s.add_dependency 'rubyzip', '>= 2.3', '< 3'
  s.add_dependency 'thor', '~> 1.3'
  s.add_dependency 'tomlrb', '>= 1.3', '< 2.1'
  s.add_dependency 'with_env', '~> 1.1'
  s.add_dependency 'xml-simple', '~> 1.1', '>= 1.1.9'

  s.add_development_dependency 'addressable',  '~> 2.8'
  s.add_development_dependency 'capybara',     '~> 3.40'
  s.add_development_dependency 'cocoapods',    '>= 1.15' if RUBY_PLATFORM.match?(/darwin/)
  s.add_development_dependency 'fakefs',       '~> 2.5'
  s.add_development_dependency 'mime-types',   '~> 3.6'
  s.add_development_dependency 'pry',          '~> 0.14'
  s.add_development_dependency 'rake',         '~> 13.2'
  s.add_development_dependency 'rspec',        '~> 3.13'
  s.add_development_dependency 'rspec-its',    '~> 1.3'
  s.add_development_dependency 'rubocop',      '~> 1.66'
  s.add_development_dependency 'rubocop-performance', '~> 1.22'
  s.add_development_dependency 'webmock',      '~> 3.23'

  s.add_development_dependency 'nokogiri',  '~> 1.16'
  s.add_development_dependency 'rack',      '~> 3.1'
  s.add_development_dependency 'rack-test', '~> 2.1'

  s.files       = `git ls-files`.split("\n").reject { |f| f.start_with?('spec', 'features') }
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
end
