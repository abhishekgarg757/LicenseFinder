# Contributing

Thanks for your interest in contributing to `licensefinder`!

## TL;DR

* Fork the project from <https://github.com/abhishekgarg757/licensefinder>.
* Create a feature branch off `main`.
* Make your feature addition or bug fix. Please make sure there is appropriate
  test coverage.
* Rebase on top of `main`.
* Open a pull request. Please add a `CHANGELOG.md` entry following the
  [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) convention.

## Running Tests

The easiest way to get a fully provisioned environment with every supported
package manager already installed is to use the project's Docker image.

```sh
./dlf rake spec
./dlf bundle exec rake features
```

The `spec` task runs all unit tests; the `features` task runs the
end-to-end feature tests. Feature tests must be wrapped in `bundle exec`
so they use the gem from your working tree rather than the gem already
installed inside the image.

You can also run the suite directly on your machine as long as you have
Ruby 3.1 or newer and the relevant package managers installed:

```sh
bundle install
bundle exec rake spec
bundle exec rake features
```

## Building the Docker image locally

```sh
docker build -t abhishekgarg757/licensefinder:dev .
docker run -v "$PWD":/scan -it abhishekgarg757/licensefinder:dev /bin/bash -l
```

`-v "$PWD":/scan` mounts your current working directory inside the
container at `/scan`, which is also the working directory used by the
`dlf` helper script.

## Adding Package Managers

The behaviour required of a package manager is documented in
[`lib/license_finder/package_manager.rb`](lib/license_finder/package_manager.rb).

Each package manager has matching unit and feature tests. Good
references are:

* Feature tests: [`features/features/package_managers`](features/features/package_managers)
* Unit tests: [`spec/lib/license_finder/package_managers`](spec/lib/license_finder/package_managers)

## Adding Licenses

Add new licenses to
[`lib/license_finder/license/definitions.rb`](lib/license_finder/license/definitions.rb).
The MIT license is a good example of a definition that supports multiple
matching strategies.

## Adding Reports

If you need `license_finder` to output additional package data, consider
opening a pull request that adds new columns to
[`lib/license_finder/reports/csv_report.rb`](lib/license_finder/reports/csv_report.rb).

You can also generate a custom report from an ERB template; see
[`examples/custom_erb_template.rb`](examples/custom_erb_template.rb)
as a starting point. These reports have access to the helpers in
[`LicenseFinder::ErbReport`](lib/license_finder/reports/erb_report.rb).

## Development Dependencies

To run the full test suite on your machine you will need the following
installed:

- Node.js, NPM, Yarn, PNPM, Bower
- Java, Maven, Gradle
- Python 3, pip
- Erlang, Rebar3, Elixir/Mix
- Go (modules and legacy GOPATH tooling: GoDep, Gvt, govendor, Glide, Trash)
- CocoaPods (Ruby)
- Bundler
- Carthage
- Conan
- NuGet, .NET SDK
- Conda
- Cargo (Rust)
- Composer (PHP)
- Swift / Swift Package Manager
- Flutter

The project's Docker image already contains all of these.

Run `rake check_dependencies` to see which package managers are missing
on your system.

## Code Style

The project uses RuboCop. Run it with:

```sh
bundle exec rake rubocop
```
