# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-04-30

First release of `licensefinder` under the new maintainer
([@abhishekgarg757](https://github.com/abhishekgarg757)). This project is a
continuation of the unmaintained
[`pivotal/LicenseFinder`](https://github.com/pivotal/LicenseFinder) gem.

### Added
- Modernised tech stack across the board:
  - Ruby `>= 3.1` with the gem tested against Ruby 3.1, 3.2 and 3.3.
  - Refreshed runtime/dev gem dependencies (`thor`, `rubyzip`, `nokogiri`,
    `rack`, `rubocop`, `webmock`, `fakefs`, `pry`, `rake`, etc.).
- Modernised Docker image based on **Ubuntu 24.04 (Noble Numbat)** and
  shipping the latest stable toolchains:
  - Ruby 3.3, Node.js 22 LTS, Go 1.23, OpenJDK 21, Gradle 8.10,
    Maven 3.9, SBT 1.10, .NET SDK 8.0, PHP 8.3, Composer 2,
    Flutter 3.24, Swift 5.10, Rust (latest stable via rustup),
    Conan 1 (latest stable in the 1.x line for backwards-compatibility).
- GitHub Actions CI pipelines (test, lint, Docker publish, gem release)
  replacing the previous Concourse / AppVeyor pipelines.

### Changed
- Repository moved to `https://github.com/abhishekgarg757/licensefinder`.
- Default Docker image renamed to `abhishekgarg757/licensefinder`.
- Documentation rewritten to reflect the new home and tooling.

### Removed
- Legacy AppVeyor configuration and Concourse pipelines.
- References to the previous maintainer's hosted CI and mailing list.

### Notes
- The original Pivotal copyright is retained in `LICENSE` as required by
  the MIT license.
- Historical changelog entries from the original project are not carried
  here; see the upstream repository for releases prior to this one.
