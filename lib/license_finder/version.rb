# frozen_string_literal: true

module LicenseFinder
  root    = File.expand_path('../..', __dir__)
  VERSION = File.read("#{root}/version.txt").strip
end
