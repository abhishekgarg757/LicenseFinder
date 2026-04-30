# Release Process

Releases are cut from `main`. Conventional flow:

## 1. Prepare

* Decide the new version (SemVer):
  - patch — bug fixes only
  - minor — new package manager / new license / new report format
  - major — removes a package manager, changes CLI flags, or bumps the
    minimum Ruby version

* Move CHANGELOG entries from *Unreleased* into a new
  `## [X.Y.Z] - YYYY-MM-DD` section in
  [`CHANGELOG.md`](../CHANGELOG.md).

* Bump [`VERSION`](../VERSION).

## 2. Commit + tag + push

```bash
git checkout main
git pull
git commit -am "chore(release): X.Y.Z"
git tag -a vX.Y.Z -m "vX.Y.Z"
git push origin main
git push origin vX.Y.Z
```

## 3. Automated steps (after the tag push)

| Workflow | What happens |
| --- | --- |
| `docker-publish.yml` | Builds image, pushes `abhishekgarg757/licensefinder:X.Y.Z`, `:X.Y` and `:latest` |
| `release-gem.yml` | (disabled) — Builds the gem and pushes to RubyGems |

Watch the Actions tab. If anything fails, fix forward (don't delete
the tag — bump to `X.Y.Z+1`).

## 4. GitHub Release

Once the workflows succeed, create a GitHub Release from the tag and
paste the relevant CHANGELOG section as the description. The
`release-gem.yml` workflow does this automatically when enabled.

## Enabling RubyGems publishing

You have two routes; pick one.

### Option A — Trusted Publishing (no secrets)

Only works if you own the gem name on RubyGems.

1. Pick a gem name you own (likely **not** `license_finder` — already
   taken). Update `s.name` in
   [`license_finder.gemspec`](../license_finder.gemspec).
2. Push a placeholder version to RubyGems once with an API key (Option
   B below) so the gem exists.
3. Visit `https://rubygems.org/gems/<your-gem-name>/trusted_publishers`.
4. *Create* a GitHub trusted publisher with:
   - Repository owner: `abhishekgarg757`
   - Repository name: `LicenseFinder`
   - Workflow filename: `release-gem.yml`
5. Uncomment the `push: tags:` lines in
   [`release-gem.yml`](../.github/workflows/release-gem.yml).
6. Replace the `gem push ...` step with `rubygems/release-gem@v1`.

### Option B — API key

1. Generate a key at <https://rubygems.org/profile/api_keys> with the
   *Push rubygem* scope only.
2. Add `RUBYGEMS_API_KEY` as a GitHub repo secret.
3. Uncomment the `push: tags:` lines in
   [`release-gem.yml`](../.github/workflows/release-gem.yml).

## Hotfix releases

For urgent fixes:

1. Branch from the latest tag: `git checkout -b hotfix/X.Y.Z+1 vX.Y.Z`.
2. Apply fix + test + CHANGELOG entry.
3. Bump VERSION, commit, merge to `main` (or fast-forward), tag and push.
