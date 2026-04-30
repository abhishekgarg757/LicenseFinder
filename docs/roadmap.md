# Roadmap

Forward-looking ideas. None of these are commitments — they're a
catalogue of "things a future maintainer might pick up".

## Short term

- [ ] Run `bundle exec rubocop -A` once and commit a
      `.rubocop_todo.yml`, then make RuboCop a hard CI gate again.
- [ ] Re-enable feature tests in CI by running them inside the Docker
      image (use the `actions/docker` build + `docker run` to execute
      `rake features`).
- [ ] Publish to RubyGems under a unique name; switch on
      `release-gem.yml`.
- [ ] Add `arm64` to the Docker image's `--platform` list.
- [ ] Sign Docker images with cosign.

## Medium term

- [ ] Slim Docker images: split into `licensefinder:slim` (Ruby-only,
      lockfile parsing only) and `licensefinder:full` (every
      toolchain). Most users only need one ecosystem.
- [ ] Replace shelling out to `bundle`/`npm`/etc. with lockfile-only
      parsing wherever possible — drastically smaller image, no
      network during scan.
- [ ] First-class SBOM (CycloneDX / SPDX) report formats.
- [ ] Cache results between runs (e.g. `.licensefinder-cache.json`).
- [ ] GitHub Action wrapper for use as a marketplace action.

## Long term

- [ ] Full SPDX expression support (`Apache-2.0 OR MIT`).
- [ ] License-text fingerprint database from
      [SPDX license-list-data](https://github.com/spdx/license-list-data)
      so we don't have to maintain matchers by hand.
- [ ] Native Go / Rust binary for the lockfile-only happy path.

## Out of scope

- Re-implementing dependency resolution for any ecosystem.
- Hosting a server-side service. `licensefinder` is a CLI tool.
