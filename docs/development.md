# Development Guide

## Prerequisites

* Ruby `>= 3.1` (matching `license_finder.gemspec`)
* Bundler (`gem install bundler`)
* Git

For the full feature suite you also need every supported package
manager installed (Node, Java/Maven/Gradle, Go, Python, etc.).
Realistically: use the Docker image — see below.

## Initial setup

```bash
git clone https://github.com/abhishekgarg757/LicenseFinder.git
cd LicenseFinder
bundle install
```

## Common tasks

```bash
# Unit tests
bundle exec rspec spec

# Single spec file
bundle exec rspec spec/lib/license_finder/decisions_spec.rb

# Single example
bundle exec rspec spec/lib/license_finder/decisions_spec.rb:42

# Lint
bundle exec rubocop
bundle exec rubocop -A          # auto-fix what's safe

# Feature (end-to-end) tests — needs every package manager installed
bundle exec rake features

# Both
bundle exec rake                 # spec + features

# Tool-installation sanity check
bundle exec rake check_dependencies
```

## Run inside the Docker image (recommended)

The image bundled with this repo has every supported package manager
pre-installed. Use the `dlf` wrapper:

```bash
./dlf rake spec
./dlf bundle exec rake features
./dlf bash                       # interactive shell
```

`dlf` mounts your current working directory at `/scan` inside the
container.

## Useful environment variables

| Variable | Effect |
| --- | --- |
| `LICENSEFINDER_IMAGE` | Override the image used by `dlf` (default `abhishekgarg757/licensefinder:latest`) |
| `LF_LOG_LEVEL` | `info` / `debug` for the gem's logger |
| `BUNDLE_GEMFILE` | Run against an alternate `Gemfile` (used by tests) |

## Debugging

Drop a `binding.pry` anywhere in the code and run the scenario you want
to inspect. `pry` is a development dependency.

## Repository scripts

There are no additional scripts under `bin/` beyond the gem
executable and a Python helper for `pip`. All other automation lives in
the `Rakefile` and the GitHub Actions workflows.
