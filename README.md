# aw-server-docker

`aw-server-rust` server running in a Docker container.

A GitHub Actions workflow checks daily for new [ActivityWatch releases](https://github.com/ActivityWatch/activitywatch/releases) and automatically builds, tags, and publishes a new Docker image.

## Quick Start

```bash
docker run -d --name activitywatch \
  -p 5600:5600 \
  -v /path/to/appdata/activitywatch:/config \
  ghcr.io/graphichealer/aw-server-docker:latest
```

## Setup

1. Install ActivityWatch (`aw-qt`) on your machine, see https://docs.activitywatch.net/en/latest/getting-started.html#installation (for watchers etc.)
2. Make sure that `aw-server` is not autostarted by `aw-qt`. This can be configured in the `~/.config/activitywatch/aw-qt/aw-qt.toml` file by excluding it from the `autostart_modules` option (see an example of the `aw-qt.toml` file in this repo).

## Building Locally

To build the image locally for a specific version:

```bash
docker build --build-arg AW_VERSION=0.13.2 -t aw-server .
```

## Attribution
Based on work by sentisso.
https://github.com/sentisso/docker-activitywatch
