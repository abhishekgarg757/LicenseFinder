# Repository Layout

A guided tour of every top-level entry.

## Root files

| Path | Purpose |
| --- | --- |
| [`README.md`](../README.md) | User-facing overview, install + usage |
| [`CONTRIBUTING.md`](../CONTRIBUTING.md) | How to contribute |
| [`CHANGELOG.md`](../CHANGELOG.md) | Per-version changelog (Keep a Changelog) |
| [`RELEASING.md`](../RELEASING.md) | Release runbook (short version) |
| [`LICENSE`](../LICENSE) | MIT license + retained Pivotal copyright |
| [`NOTICE`](../NOTICE) | Attribution to upstream contributors |
| [`SECURITY.md`](../SECURITY.md) | Vulnerability disclosure policy |
| [`CODE_OF_CONDUCT.md`](../CODE_OF_CONDUCT.md) | Contributor Covenant pointer |
| [`VERSION`](../VERSION) | Single source of truth for the gem version |
| [`license_finder.gemspec`](../license_finder.gemspec) | Gem metadata + dependencies |
| [`Gemfile`](../Gemfile) | Just sources the gemspec |
| [`Rakefile`](../Rakefile) | Defines `spec`, `features`, `rubocop`, `check_dependencies` |
| [`Dockerfile`](../Dockerfile) | All-in-one image with every package manager |
| [`dlf`](../dlf) | Wrapper script that runs commands inside the Docker image |
| [`swift-all-keys.asc`](../swift-all-keys.asc) | GPG keys for verifying Swift toolchain in Docker build |
| [`.rubocop.yml`](../.rubocop.yml) | RuboCop configuration |
| [`.rspec`](../.rspec) | Default RSpec options |
| [`.gitignore`](../.gitignore) | Standard ignores (`.bundle`, `tmp/`, `pkg/*`, etc.) |
| [`.pre-commit-hooks.yaml`](../.pre-commit-hooks.yaml) | Definition for pre-commit framework consumers |

## `bin/`

| File | Purpose |
| --- | --- |
| `bin/license_finder` | Gem executable; calls `LicenseFinder::CLI::Main.start` |
| `bin/license_finder_pip.py` | Python helper invoked by the `pip` package manager |

## `lib/license_finder/`

The implementation. Notable subdirectories:

| Path | What lives here |
| --- | --- |
| `lib/license_finder.rb` | Top-level require manifest |
| `cli/` | Thor-based CLI subcommands (`approvals`, `licenses`, etc.) |
| `package_managers/` | One file per supported ecosystem (bundler, npm, maven, ...) |
| `package_utils/` | Helpers for license/notice file detection inside packages |
| `packages/` | Per-ecosystem `Package` subclasses (e.g. `BundlerPackage`) |
| `license/` | License catalogue, definitions, matchers |
| `reports/` | Report formatters (text, csv, html, json, xml, markdown, junit, diff, merged) |
| `reports/templates/` | ERB templates for HTML/Markdown reports |
| `shared_helpers/` | Cross-cutting utilities (e.g. `Cmd` shell wrapper) |
| `core.rb` | Top-level orchestrator |
| `scanner.rb` | Package-manager dispatch / aggregation |
| `decisions.rb` | YAML decisions in-memory representation |
| `decision_applier.rb` | Applies decisions to scan output |
| `decisions_factory.rb` | Builds `Decisions` from disk |
| `manual_licenses.rb` | Reconciles user-supplied license overrides |
| `license_aggregator.rb` | Multi-project rollup |
| `package.rb`, `package_delta.rb` | Package value objects + diff helper |
| `printer.rb`, `logger.rb` | Output utilities |
| `platform.rb` | OS detection (used to skip iOS specs on Linux) |
| `project_finder.rb` | Recursive project discovery (`--recursive`) |
| `report.rb` | Report dispatcher (selects formatter) |
| `version.rb` | `LicenseFinder::VERSION` constant (reads `VERSION`) |
| `configuration.rb` | Loads `config/license_finder.yml` and merges CLI flags |

## `spec/`

RSpec unit tests, mirroring the layout of `lib/`. Fixtures live in
`spec/fixtures/`.

## `features/`

End-to-end tests (also written in RSpec). Each supported package
manager has a corresponding feature spec and fixture project under
`features/fixtures/`.

## `examples/`

Reference scripts demonstrating how to consume the gem programmatically
(custom ERB templates, pulling raw license data, etc.).

## `.github/`

| Path | Purpose |
| --- | --- |
| `workflows/ci.yml` | RSpec matrix + RuboCop on every push/PR |
| `workflows/docker-publish.yml` | Build & push Docker image to Docker Hub |
| `workflows/release-gem.yml` | Build & publish gem to RubyGems (currently disabled) |
| `dependabot.yml` | Weekly dependency PRs (bundler, docker, github-actions) |
| `CODEOWNERS` | Default reviewer routing |
| `PULL_REQUEST_TEMPLATE.md` | PR checklist |
| `ISSUE_TEMPLATE/` | Bug + feature templates |

## `docs/`

You're here. See [`docs/README.md`](README.md) for the index.
