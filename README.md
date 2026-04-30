# licensefinder

[![CI](https://github.com/abhishekgarg757/licensefinder/actions/workflows/ci.yml/badge.svg)](https://github.com/abhishekgarg757/licensefinder/actions/workflows/ci.yml)
[![Docker Image](https://img.shields.io/docker/pulls/abhishekgarg757/licensefinder.svg)](https://hub.docker.com/r/abhishekgarg757/licensefinder)
[![Gem Version](https://badge.fury.io/rb/license_finder.svg)](https://rubygems.org/gems/license_finder)

`licensefinder` works with your package managers to find dependencies,
detect the licenses of the packages in them, compare those licenses
against a user-defined list of permitted licenses, and give you an
actionable exception report.

* Source: <https://github.com/abhishekgarg757/licensefinder>
* Docker image: [`abhishekgarg757/licensefinder`](https://hub.docker.com/r/abhishekgarg757/licensefinder)
  * the Docker image contains every package manager needed to run
    `license_finder` against any supported project type.
* Issues / support: <https://github.com/abhishekgarg757/licensefinder/issues>

> This is a maintained continuation of the original
> [`pivotal/LicenseFinder`](https://github.com/pivotal/LicenseFinder)
> gem, which has been unmaintained for some time. The MIT license and
> original copyright notice are retained in [`LICENSE`](LICENSE).

## Supported project types

| Project type      | Package manager | Tested with                  |
| ----------------- | --------------- | ---------------------------- |
| Ruby              | bundler         | 2.5.x                        |
| Python            | pip3 / pipenv   | pip 24.x, Python 3.12        |
| Node.js           | npm             | 10.x (Node 22 LTS)           |
| Node.js           | yarn / pnpm     | yarn 1.22 / pnpm latest      |
| Bower             | bower           | 1.8.x                        |
| Java              | maven           | 3.9.x                        |
| Java              | gradle          | 8.10                         |
| Go modules        | go              | 1.23                         |
| Go (legacy)       | godep / gvt / govendor / glide / trash | latest |
| .NET              | dotnet / nuget  | .NET SDK 8.0                 |
| PHP               | composer        | 2.x (PHP 8.3)                |
| Rust              | cargo           | latest stable (rustup)       |
| Scala             | sbt             | 1.10.x                       |
| Elixir            | mix             | latest stable                |
| Erlang            | rebar3 / Erlang.mk | latest stable             |
| Swift / Obj-C     | SPM, CocoaPods, Carthage | Swift 5.10          |
| C / C++           | conan           | 1.66 (Conan 1.x)             |
| Python (sci)      | conda           | Miniconda3                   |
| Flutter / Dart    | flutter pub     | 3.24                         |

### Experimental project types

* Erlang via `rebar` and `Erlang.mk`
* Swift via Carthage and CocoaPods (\>= 0.39)
* Elixir via `mix`
* Legacy Go via `gvt`, `glide`, `dep`, `trash`, `govendor`
* Yarn / pnpm
* C/C++ via `conan`
* Scala via `sbt`
* Rust via `cargo`
* PHP via `composer`
* Python via `conda` and `pipenv`
* Flutter via `flutter pub`

## Installation

`licensefinder` may be run as a [pre-commit](https://pre-commit.com) hook by
adding the following to your `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/abhishekgarg757/licensefinder
    rev: v1.0.0 # You probably want the latest tag.
    hooks:
      - id: license-finder
```

Running `licensefinder` directly requires Ruby 3.1 or greater. The
easiest way to install it is as a command line tool:

```sh
gem install license_finder
```

If you are using Bundler in a Ruby project you can add it to your
`Gemfile` instead (this can pull in unwanted dev dependencies — see
[Excluding Dependencies](#excluding-dependencies) to mitigate):

```ruby
gem 'license_finder', group: :development
```

## Usage

Make sure your dependencies are installed (`bundle install`,
`npm install`, etc.) then run:

```sh
license_finder
```

The first time you run `license_finder` it will list all your project's
packages. Over time you'll tell `license_finder` which packages are
approved, so when you run this command in the future it will report
current action items — i.e. packages that are new or have never been
approved.

Useful flags:

* `--quiet` — suppress progress dots.
* `--debug` — emit debugging output about packages, dependencies and how
  each license was discovered.
* `--prepare` / `-p` — run each active package manager's prepare command
  (e.g. `bundle install`, `npm install`) before scanning.
* `--prepare-no-fail` — like `--prepare` but continues despite failures.

Run `license_finder help` to see all available commands and
`license_finder help [COMMAND]` for detailed help on a specific command.

### Docker

If you have Docker installed, the included `dlf` script (optionally
symlinked into your `PATH`, e.g. `ln -s "$PWD/dlf" /usr/local/bin/dlf`)
will run any command inside a pre-provisioned Docker container with
consistent versions of every supported package manager:

```sh
$ dlf license_finder --help

$ dlf "bundle install && license_finder"
```

The script mounts the current working directory at `/scan` inside the
container. If your command contains `&&`, quote the whole thing.

The Docker image runs whichever version of the gem is installed inside
it, so the image tagged `1.0.0` runs `licensefinder` 1.0.0.

### Activation

`license_finder` automatically activates a package manager when it
detects a known project file in the current directory. Examples:

* `Gemfile` (`bundler`)
* `requirements.txt` (`pip`), `Pipfile.lock` (`pipenv`)
* `package.json` (`npm`), `yarn.lock` (`yarn`)
* `pom.xml` (`maven`)
* `build.gradle` / `build.gradle.kts` (`gradle`)
* `bower.json` (`bower`)
* `Podfile` (`pod`)
* `Cartfile` (`carthage`)
* `Package.swift` / `workspace-state.json` (`spm`)
* `rebar.config` (`rebar`), `Erlang.mk` (`Erlang.mk`)
* `mix.exs` (`mix`)
* `*.csproj` (`dotnet`), `packages/` directory (`nuget`)
* `vendor/manifest`, `glide.lock`, `vendor/vendor.json`,
  `Gopkg.lock`, `Godeps/Godeps.json`, `*.envrc`, `vendor.conf` (Go)
* `go.mod` (`go modules`)
* `conanfile.txt` (`conan`)
* `build.sbt` (`sbt`)
* `Cargo.lock` (`cargo`)
* `composer.lock` (`composer`)
* `environment.yml` (`conda`)
* `pubspec.yaml` + `.pub-cache` (`flutter`)

### Continuous Integration

`license_finder` returns a non-zero exit status when there are
unapproved dependencies, which makes it easy to fail a CI build when
someone adds an unapproved dependency.

## Approving Dependencies

If your business decides an unapproved dependency is acceptable, the
easiest way to approve it is:

```sh
license_finder approvals add awesome_gpl_gem
```

To approve a specific version or record who approved it and why:

```sh
license_finder approvals add awesome_gpl_gem --version=1.0.0
license_finder approvals add awesome_gpl_gem --who CTO --why "Go ahead"
```

### Permitting Licenses

If your business has blanket policies, mark whole licenses as permitted:

```sh
license_finder permitted_licenses add MIT
```

Any package using a permitted license is excluded from
`action_items` output.

## Output and Artifacts

### Decisions file

Decisions are recorded in `doc/dependency_decisions.yml`. Commit this
file to version control. Decisions have timestamps and are processed
top-to-bottom.

### Reports

`license_finder report` produces human-readable reports in `text`,
`csv`, `html` or `markdown` format. Output is written to STDOUT so you
can pipe it wherever you want:

```sh
license_finder report --format html > licenses.html
```

The HTML report's project name can be set with
`license_finder project_name add`.

> **Yarn note:** when a `node_module`'s `package.json` doesn't declare a
> license, Yarn appends `*` to the inferred license name; this is
> intentional.

See [CONTRIBUTING.md](CONTRIBUTING.md#adding-reports) for advice on
adding and customising reports.

## Manual Intervention

### Setting Licenses

```sh
license_finder licenses add my_unknown_dependency MIT
license_finder licenses add my_unknown_dependency MIT --version=1.0.0

# remove
license_finder licenses remove my_unknown_dependency
license_finder licenses remove my_unknown_dependency MIT
license_finder licenses remove my_unknown_dependency --version=1.0.0
license_finder licenses remove my_unknown_dependency MIT --version=1.0.0
```

Adding a license to a specific version overwrites any "all versions"
license previously set, and vice versa.

### Adding Hidden Dependencies

For dependencies your package managers don't know about (e.g. JS
libraries vendored outside `package.json`):

```sh
license_finder dependencies add my_js_dep MIT 0.1.2
license_finder dependencies remove my_js_dep
```

### Excluding Dependencies

```sh
license_finder ignored_groups          # exclude dev/test groups
license_finder ignored_dependencies    # exclude individual packages
```

Currently `ignored_groups` works for `bundler`, `npm`, `yarn`, `maven`,
`pip3` and `nuget`.

### Restricting Licenses

```sh
license_finder restricted_licenses add GPL-3.0
```

Dependencies whose licenses are *all* restricted will always appear in
the action items, even if they would otherwise be approved.

## Decision inheritance

Centralise approval/restriction lists across projects with:

```sh
license_finder inherited_decisions add DECISION_FILE
license_finder inherited_decisions remove DECISION_FILE
license_finder inherited_decisions list
```

## Configuration

By default the decisions file lives at `doc/dependency_decisions.yml`.
Pass `--decisions_file` to override.

### Narrow down package managers

```sh
license_finder --enabled-package-managers bundler npm
```

### Saving Configuration

Defaults can be stored in `config/license_finder.yml`:

```yaml
---
decisions_file: './some_path/decisions.yml'
gradle_command: './gradlew'
rebar_command: './rebarw'
rebar_deps_dir: './rebar_deps'
mix_command: './mixw'
mix_deps_dir: './mix_deps'
enabled_package_managers:
  - bundler
  - gradle
  - rebar
  - mix
```

### Gradle Projects

`license_finder` supports modern Gradle (8.x is shipped in the Docker
image). You need the
[license-gradle-plugin](https://github.com/hierynomus/license-gradle-plugin)
applied in your project. To report on a non-default configuration:

```groovy
downloadLicenses {
  dependencyConfiguration "implementation"
}
```

### Conan Projects

```
[imports]
., license* -> ./licenses @ folder=True, ignore_case=True
```

### SBT Projects

`license_finder` supports SBT via
[sbt-license-report](https://github.com/sbt/sbt-license-report). To
report on a non-default configuration:

```scala
licenseConfigurations := Set("compile", "provided")
```

## Requirements

`license_finder` requires Ruby `>= 3.1`.

## Upgrading from the upstream `pivotal/LicenseFinder`

This release is API-compatible with `pivotal/LicenseFinder` 7.x. The
gem name on RubyGems remains `license_finder`. If you are upgrading
from very old versions, the same migration notes apply:

* From `>= 6.0` you must use `permit` / `restrict` instead of the
  legacy `whitelist` / `blacklist` terminology in
  `dependency_decisions.yml`.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) and the long-form
[`docs/`](docs/README.md) directory for architecture notes, the
release process, maintenance runbook and roadmap.

## License

`licensefinder` is released under the [MIT License](LICENSE).
