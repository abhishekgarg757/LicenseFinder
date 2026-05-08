# Release Process

Releases are fully automated via
[Release Please](https://github.com/googleapis/release-please).

## How it works

1. **Write conventional commits** on `main`:
   - `feat: add Cargo support` → bumps **minor**
   - `fix: handle nil license` → bumps **patch**
   - `feat!: drop Ruby 3.0` or `BREAKING CHANGE:` footer → bumps **major**
   - `chore:`, `docs:`, `ci:`, `test:` → included in CHANGELOG under
     their own sections but don't bump version on their own.

2. **Release Please opens a PR** automatically after every push to
   `main`. The PR title looks like `chore(main): release X.Y.Z` and
   contains:
   - Updated `CHANGELOG.md` with grouped commit messages
   - Bumped `version.txt`

3. **Merge the release PR** when ready. Release Please then:
   - Creates a `vX.Y.Z` Git tag
   - Creates a GitHub Release with the changelog

4. **Tag push triggers downstream workflows**:
   - `release-gem.yml` → builds and publishes the gem to RubyGems
   - `docker-publish.yml` → pushes Docker images tagged `X.Y.Z`,
     `X.Y`, and `latest`

## Manual override

You can still cut a release manually if needed:

```bash
git checkout main
git pull
# Edit version.txt and CHANGELOG.md
git commit -am "chore(release): X.Y.Z"
git tag -a vX.Y.Z -m "vX.Y.Z"
git push origin main
git push origin vX.Y.Z
```

## Version semantics

| Change type | Version bump |
| --- | --- |
| Bug fixes only | patch |
| New package manager / license / report format | minor |
| Removes a package manager, changes CLI flags, bumps minimum Ruby | major |
2. Apply fix + test + CHANGELOG entry.
3. Bump `version.txt`, commit, merge to `main` (or fast-forward), tag and push.
