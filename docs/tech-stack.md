# Tech Stack

## Runtime

| Layer | Choice | Notes |
| --- | --- | --- |
| Language | Ruby `>= 3.1` (tested 3.1, 3.2, 3.3) | Defined in `license_finder.gemspec` |
| CLI framework | [`thor`](https://github.com/rails/thor) ~> 1.3 | Subcommand dispatch in `cli/` |
| YAML | Ruby stdlib + `tomlrb` for TOML | TOML used by some package managers (Cargo, Pipfile) |
| Archives | `rubyzip` | Used to inspect JARs and zip-based packages |
| HTTP | `webmock` (tests only) | Production code uses Ruby `Net::HTTP` |
| Templates | ERB (stdlib) | Drives HTML/Markdown reports |
| XML | `xml-simple`, `nokogiri` (dev) | Parsing pom.xml, plist, NuGet metadata |

## Test / lint

| Tool | Purpose |
| --- | --- |
| `rspec` | Unit + feature tests |
| `rspec-its` | `its(...)` matcher syntax |
| `webmock` | HTTP stubbing |
| `fakefs` | In-memory filesystem for tests |
| `rubocop` + `rubocop-performance` | Style/lint |
| `pry` | Interactive debugging |
| `rake` | Task runner |

## Tooling shipped in the Docker image

See [docker.md](docker.md) for full version pins. Brief summary:

- Ruby 3.3 (rbenv-managed)
- Node.js 22 LTS, Yarn, pnpm, Bower
- OpenJDK 21, Maven, Gradle 8.10, SBT 1.10
- Go 1.23 (+ legacy GOPATH tools: godep, gvt, govendor, glide, trash)
- Python 3.12 + pip, pipenv, conan
- Erlang, Elixir, rebar3
- Rust (rustup stable)
- .NET SDK 8.0 + nuget via mono
- PHP 8.3 + Composer 2
- Swift 5.10 (Swift Package Manager)
- Flutter 3.24
- Miniforge3 (conda)

## Build / release

| Tool | Purpose |
| --- | --- |
| GitHub Actions | CI, Docker publish, gem publish |
| Docker Buildx | Multi-stage container builds |
| Docker Hub | Image hosting (`abhishekgarg757/licensefinder`) |
| RubyGems | Gem hosting (currently disabled — see [release-process.md](release-process.md)) |
