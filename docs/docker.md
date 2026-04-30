# Docker

The [`Dockerfile`](../Dockerfile) at the repo root produces an image
with every supported package manager pre-installed, plus the gem
itself, so users can scan any project without installing toolchains
locally.

## Image name

Published as
[`abhishekgarg757/licensefinder`](https://hub.docker.com/r/abhishekgarg757/licensefinder)
on Docker Hub.

## Build locally

```bash
docker build -t abhishekgarg757/licensefinder:dev .
```

Build is slow (≈30 min on a laptop) — every toolchain is downloaded
fresh. Layer caching helps a lot on rebuilds.

## Run locally

```bash
# Interactive
docker run --rm -v "$PWD":/scan -it abhishekgarg757/licensefinder:dev /bin/bash -l

# One-shot scan
docker run --rm -v "$PWD":/scan abhishekgarg757/licensefinder:dev license_finder
```

The `dlf` wrapper script does all this for you.

## What's inside

See [tech-stack.md](tech-stack.md) for full version table. The image is
built in roughly this order:

1. Base OS deps (`build-essential`, curl, git, locales, GPG, etc.)
2. Node.js 22 + Yarn + pnpm + Bower
3. OpenJDK 21 + Maven
4. Gradle, SBT
5. Go + legacy GOPATH tools (godep, gvt, govendor)
6. Python + pipx-installed conan and pipenv
7. rebar3, Erlang, Elixir
8. Rust via rustup
9. .NET SDK + mono + nuget.exe
10. PHP + Composer
11. Miniforge3 (conda)
12. Swift toolchain (GPG-verified)
13. Flutter
14. Ruby via rbenv (compiled from source for `RUBY_VERSION`)
15. Rancher trash (legacy Go vendor)
16. The gem itself (`bundle install && rake install`)

## Publishing to Docker Hub

Two paths:

### Automatic (CI)

[`docker-publish.yml`](../.github/workflows/docker-publish.yml) runs on:

- every push to `main` (publishes `:main`)
- every `v*.*.*` tag (publishes `:X.Y.Z`, `:X.Y`, `:latest`)
- manual `workflow_dispatch`

Required GitHub Actions secrets:

| Secret | Value |
| --- | --- |
| `DOCKERHUB_USERNAME` | `abhishekgarg757` |
| `DOCKERHUB_TOKEN` | A Docker Hub *Read & Write* personal access token |

### Manual

```bash
docker login -u abhishekgarg757
docker buildx create --use --name lfbuilder 2>/dev/null || true
docker buildx build \
  --platform linux/amd64 \
  -t abhishekgarg757/licensefinder:1.0.0 \
  -t abhishekgarg757/licensefinder:latest \
  --push .
```

## Troubleshooting build failures

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| `rbenv: no such command 'install'` | Missing `RBENV_ROOT` env var | Already set in Dockerfile |
| `tar: <name>: Not found in archive` | Tarball layout changed upstream | Extract to a temp dir then `find ... -exec mv` |
| `gpg: bad signature` (Swift step) | Swift signing key rotated / expired | Refresh `swift-all-keys.asc` from <https://swift.org/keys/all-keys.asc> |
| `apt-get` 404 on a PPA | Distribution name changed (e.g. jammy → noble) | Update the `echo "deb ..."` source list |
| Image > 10 GB | Cache layers retained | Ensure each `apt` layer ends with `rm -rf /var/lib/apt/lists/*` |
