# aw-server-docker

`aw-server-rust` server running in an automatically updated Docker container, published to the GitHub Container Registry (GHCR).

A GitHub Actions workflow checks daily for new [ActivityWatch releases](https://github.com/ActivityWatch/activitywatch/releases) and automatically builds, tags, and publishes a new Docker image.

## Quick Start

```bash
docker pull ghcr.io/graphichealer/aw-server-docker:latest
docker run -d --name activitywatch \
  -p 5600:5600 \
  -v /path/to/appdata/activitywatch:/config \
  ghcr.io/graphichealer/aw-server-docker:latest
```

Or use `docker compose`:

```bash
docker compose up -d
```

## Setup

1. Install ActivityWatch (`aw-qt`) on your machine, see https://docs.activitywatch.net/en/latest/getting-started.html#installation (for watchers etc.)
2. Make sure that `aw-server` is not autostarted by `aw-qt`. This can be configured in the `~/.config/activitywatch/aw-qt/aw-qt.toml` file by excluding it from the `autostart_modules` option (see an example of the `aw-qt.toml` file in this repo).
3. Update the volume path in `docker-compose.yml` to your desired appdata location.
4. `docker compose up -d` 🎉

### Volume Layout

All persistent data is stored under a single `/config` mount (LinuxServer.io / Unraid style):

```
/config/
  config/    # ActivityWatch configuration files
  data/      # ActivityWatch database and data files
```

## Image Tags

- **`latest`** — always points to the most recent ActivityWatch release
- **`X.Y.Z`** — pinned to a specific ActivityWatch version (e.g. `0.13.2`)

## Updates

The Docker image is **automatically rebuilt** whenever a new ActivityWatch release is detected. The GitHub Actions workflow runs daily and:

1. Queries the [ActivityWatch releases API](https://api.github.com/repos/ActivityWatch/activitywatch/releases/latest) for the latest version
2. Skips the build if that version tag already exists in GHCR
3. Builds and pushes the image with both the version tag and `latest`

To update your running container, simply pull the latest image:

```bash
docker compose pull
docker compose up -d
```

You can also trigger a build manually from the Actions tab, with an option to force-rebuild an existing version.

## Unraid

This container is compatible with Unraid and includes a Community Applications (CA) template.

### Install via Community Applications

Once submitted and approved, search for **ActivityWatch** in the Unraid CA store.

### Manual Install on Unraid

1. In the Unraid web UI, go to **Docker** > **Add Container**
2. Set **Template Repository URL** to:
   ```
   https://raw.githubusercontent.com/GraphicHealer/aw-server-docker/main/unraid-templates/aw-server-docker.xml
   ```
3. Click **Apply** — the template will auto-fill all settings
4. Adjust the appdata path if needed (default: `/mnt/user/appdata/activitywatch`)
5. Click **Apply** to create the container

The Unraid template is automatically updated with the latest version each time a new Docker image is built.

## Building Locally

To build the image locally for a specific version:

```bash
docker build --build-arg AW_VERSION=0.13.2 -t aw-server .
```


## Attribution
Based on work by sentisso.
https://github.com/sentisso/docker-activitywatch
