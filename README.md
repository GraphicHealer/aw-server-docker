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

Since the server runs in Docker, you only need the ActivityWatch **client watchers** on your machine. The watchers collect activity data and send it to the server.

### 1. Install ActivityWatch

Download and install ActivityWatch on your machine from the [official site](https://docs.activitywatch.net/en/latest/getting-started.html#installation).

### 2. Locate your ActivityWatch config directory

| OS | Config Directory |
|---|---|
| **Linux** | `~/.config/activitywatch/` |
| **macOS** | `~/Library/Application Support/activitywatch/` |
| **Windows** | `%LOCALAPPDATA%\activitywatch\activitywatch\` |

All config file paths below are relative to this directory.

### 3. Disable the local `aw-server`

The server is running in Docker, so you need to prevent `aw-qt` from starting its own local server. Edit `aw-qt/aw-qt.toml` and remove `aw-server` from the `autostart_modules` list:

```toml
[aw-qt]
autostart_modules = ["aw-watcher-afk", "aw-watcher-window"]
```

The default config has `aw-server` included — simply remove it and uncomment the line. An example config is included in this repo as [`aw-qt.toml`](aw-qt.toml).

### 4. Point watchers at the Docker server

If the Docker container is running on the same machine, the watchers will connect to `localhost:5600` by default and no extra configuration is needed.

If the server is on a **different host**, edit `aw-client/aw-client.toml` and uncomment the hostname and port lines:

```toml
[server]
hostname = "your-server-ip"
port = "5600"
```

### 5. Start the container

```bash
docker run -d --name activitywatch \
  -p 5600:5600 \
  -v /path/to/appdata/activitywatch:/config \
  ghcr.io/graphichealer/aw-server-docker:latest
```

### 6. Verify

Open `http://localhost:5600` in your browser to access the ActivityWatch web UI.

## Building Locally

To build the image locally for a specific version:

```bash
docker build --build-arg AW_VERSION=0.13.2 -t aw-server .
```

## Attribution
Based on work by sentisso.
https://github.com/sentisso/docker-activitywatch
