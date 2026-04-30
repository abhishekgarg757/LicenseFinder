# Architecture

`licensefinder` is a Ruby command line tool with one job: scan a
project, figure out which third-party packages it depends on, look up
each package's license, and compare the result against rules the user
has expressed in a YAML decisions file.

## High-level data flow

```
+--------------+      +----------------+      +------------------+
| Project dir  | ---> | Scanner        | ---> | List of Packages |
|  (Gemfile,   |      | (per package   |      | (name, version,  |
|  package.json|      |  manager)      |      |  license, paths) |
|  ...)        |      +----------------+      +------------------+
+--------------+              |                         |
                              v                         v
                       +----------------+     +-----------------+
                       | Decisions YAML | --> | DecisionApplier |
                       | (approvals,    |     | (apply rules,   |
                       |  permits,      |     |  surface action |
                       |  restrictions) |     |  items)         |
                       +----------------+     +-----------------+
                                                       |
                                                       v
                                            +---------------------+
                                            | Reports             |
                                            | (text/csv/html/json |
                                            |  /xml/markdown/     |
                                            |  junit)             |
                                            +---------------------+
```

## Core abstractions

| Class | File | Responsibility |
| --- | --- | --- |
| `LicenseFinder::CLI::Main` | [lib/license_finder/cli/main.rb](../lib/license_finder/cli/main.rb) | Thor-based CLI entry point. Dispatches to subcommands. |
| `LicenseFinder::Core` | [lib/license_finder/core.rb](../lib/license_finder/core.rb) | Top-level orchestrator wiring scanner + decisions + reports together. |
| `LicenseFinder::Scanner` | [lib/license_finder/scanner.rb](../lib/license_finder/scanner.rb) | Iterates active package managers and aggregates packages. |
| `LicenseFinder::PackageManager` | [lib/license_finder/package_manager.rb](../lib/license_finder/package_manager.rb) | Abstract base class for all package-manager integrations. |
| `LicenseFinder::Package` | [lib/license_finder/package.rb](../lib/license_finder/package.rb) | Value object: name, version, licenses, install path, etc. |
| `LicenseFinder::License` | [lib/license_finder/license.rb](../lib/license_finder/license.rb) | License catalogue + matchers (text, SPDX id, alternative names). |
| `LicenseFinder::Decisions` | [lib/license_finder/decisions.rb](../lib/license_finder/decisions.rb) | In-memory representation of `dependency_decisions.yml`. |
| `LicenseFinder::DecisionApplier` | [lib/license_finder/decision_applier.rb](../lib/license_finder/decision_applier.rb) | Combines packages + decisions to produce action items. |
| `LicenseFinder::Reports::*` | [lib/license_finder/reports/](../lib/license_finder/reports/) | Output formatters; one class per format. |

## Lifecycle of a `license_finder` invocation

1. **CLI parses arguments** (`bin/license_finder` -> `CLI::Main`).
2. **Configuration is loaded** from CLI flags + `config/license_finder.yml`.
3. **Scanner activates** every package manager whose project file is
   present (e.g. `Gemfile` triggers `Bundler`, `package.json` triggers
   `Npm`).
4. Each `PackageManager#current_packages` shells out to the underlying
   tool (`bundle`, `npm`, `mvn`, etc.) or parses lockfiles to produce
   `Package` objects.
5. The aggregated package list is matched against the catalogue in
   `License::Definitions` to attach licenses.
6. `Decisions` is loaded from `doc/dependency_decisions.yml` (plus any
   inherited files).
7. `DecisionApplier` walks the package list:
   * skip packages explicitly approved
   * skip packages whose license is in `permitted_licenses`
   * always flag packages whose only license is in
     `restricted_licenses`
   * flag everything else as an action item
8. The chosen `Reports::*` formatter renders the result; `action_items`
   exits non-zero when there are unresolved findings.

## Key design choices

* **Plugin-style package managers.** Adding a new ecosystem is a single
  file in `lib/license_finder/package_managers/` plus a fixture and a
  spec.
* **Pluggable reports.** Same pattern under
  `lib/license_finder/reports/`.
* **No central database.** State is two YAML files in your repo:
  decisions and (optionally) configuration.
* **Shells out to native tooling.** `licensefinder` does not re-implement
  resolvers; it uses each ecosystem's own package manager. That keeps it
  accurate but is why the Docker image is large — every supported
  toolchain is bundled.
