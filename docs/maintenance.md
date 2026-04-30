# Maintenance

Routine work needed to keep the project healthy.

## Weekly

* Triage incoming issues / PRs.
* Review Dependabot PRs:
  - Bundler bumps: merge if CI is green.
  - Docker base image: trigger a manual `docker-publish` run after
    merging.
  - Actions versions: usually safe to merge.

## Monthly

* Re-run `docker-publish` from the Actions tab to refresh the
  `:latest` image with the newest OS security patches even if no code
  has changed.
* Skim `bundle outdated` for indirect deps not handled by Dependabot.
* Confirm CI badges in the README still work.

## Quarterly

* Bump the supported Ruby matrix in [`ci.yml`](../.github/workflows/ci.yml)
  to drop EOL Rubies and add new stable releases.
* Bump pinned tool versions in the [`Dockerfile`](../Dockerfile)
  (`GO_VERSION`, `GRADLE_VERSION`, `NODE_MAJOR`, `RUBY_VERSION`,
  `FLUTTER_VERSION`, `SWIFT_VERSION`, etc.).
* Refresh `swift-all-keys.asc` if the Swift signing key has rotated
  (see <https://swift.org/keys/all-keys.asc>).

## Per-release

See [release-process.md](release-process.md).

## Triage cheatsheet

| Issue type | Suggested action |
| --- | --- |
| Bug in a specific package manager | Reproduce in the Docker image first. If reproducible, fix the relevant `lib/license_finder/package_managers/<pm>.rb` and add a regression spec. |
| New license not detected | Add a definition to `lib/license_finder/license/definitions.rb`. |
| Request for new package manager | Point user at [package-managers.md](package-managers.md). |
| Docker image build fails on a transitive tool | Pin a known-good version in the Dockerfile and update [docker.md](docker.md). |
| RubyGems / supply chain CVE | Bump the offending dep, cut a patch release immediately. |

## Long-running concerns

* **Docker image size.** Already large (~6-7 GB). Resist adding new
  toolchains unless they're commonly requested.
* **Legacy Go tooling.** `godep`, `gvt`, `govendor`, `glide`, `trash`
  are dead projects. Don't remove them silently — gate any removal
  behind a major version bump and a CHANGELOG note.
* **Swift / Flutter** download URLs change format every few releases;
  expect to touch those layers at every quarterly bump.
