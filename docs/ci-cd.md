# CI / CD

All automation runs on GitHub Actions in [`.github/workflows/`](../.github/workflows/).

## Workflows

### `ci.yml`

Runs on every push to `main` and every PR.

* `rspec` — matrix over Ruby 3.1, 3.2, 3.3. Excludes specs that shell
  out to real binaries (`go_dep_spec`, `gradle_spec`,
  `scanner_spec`); those are exercised inside the Docker image.
* `rubocop` — runs `rubocop --parallel` with `continue-on-error: true`
  so cosmetic offences don't block merges. Tighten this once
  `.rubocop_todo.yml` has been generated.

### `docker-publish.yml`

Triggers: push to `main`, `v*.*.*` tags, or manual dispatch.

Builds and pushes images to Docker Hub. See [docker.md](docker.md).

### `release-gem.yml`

Currently **disabled** (only `workflow_dispatch` is active). To
re-enable, uncomment the `push: tags:` block. Requires either:

* Trusted Publishing configured at
  <https://rubygems.org/gems/<your-gem>/trusted_publishers>, **or**
* a `RUBYGEMS_API_KEY` repository secret.

See [release-process.md](release-process.md).

## Required secrets

| Secret | Used by | Purpose |
| --- | --- | --- |
| `DOCKERHUB_USERNAME` | docker-publish | Docker Hub auth |
| `DOCKERHUB_TOKEN` | docker-publish | Docker Hub PAT |
| `RUBYGEMS_API_KEY` | release-gem | RubyGems push token (when enabled) |

## Dependabot

[`.github/dependabot.yml`](../.github/dependabot.yml) opens weekly PRs
for:

* Bundler dependencies (the gemspec)
* Docker base image (`Dockerfile`'s `FROM` line)
* GitHub Actions versions

## Branch protection (recommended)

Settings → Branches → Add rule for `main`:

* Require PR before merging
* Require status checks: `RSpec (Ruby 3.3)` (and the others if you
  want)
* Require branches to be up to date
* Disallow force pushes
