# Releasing `licensefinder`

Releases are cut from `main`.

1. Bump the version in [`VERSION`](VERSION) following SemVer.
2. Add an entry to [`CHANGELOG.md`](CHANGELOG.md) under a new
   `## [X.Y.Z] - YYYY-MM-DD` heading.
3. Commit, tag and push:

   ```sh
   git commit -am "Release vX.Y.Z"
   git tag vX.Y.Z
   git push origin main vX.Y.Z
   ```

4. Pushing the `vX.Y.Z` tag triggers two GitHub Actions workflows:
   * [`release-gem.yml`](.github/workflows/release-gem.yml) builds and
     publishes the gem to RubyGems via the Trusted Publishers flow
     (configure the `license_finder` gem on RubyGems to trust this
     repository's `release-gem.yml` workflow).
   * [`docker-publish.yml`](.github/workflows/docker-publish.yml) builds
     and pushes `abhishekgarg757/licensefinder:X.Y.Z`,
     `abhishekgarg757/licensefinder:X.Y` and
     `abhishekgarg757/licensefinder:latest` to Docker Hub.

You can also manually run the workflows from the Actions tab.
