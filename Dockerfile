FROM debian:bookworm-slim

ARG AW_VERSION

LABEL maintainer="GraphicHealer"
LABEL repository="https://github.com/GraphicHealer/aw-server-docker"
LABEL org.opencontainers.image.source="https://github.com/GraphicHealer/aw-server-docker"
LABEL org.opencontainers.image.description="ActivityWatch server (aw-server-rust) running in Docker"
LABEL org.opencontainers.image.version="${AW_VERSION}"

# Install dependencies
RUN apt-get update && apt-get install -y ca-certificates unzip wget \
  && rm -rf /var/lib/apt/lists/*

# Create working directory
RUN mkdir /app
WORKDIR /app

# Download and extract ActivityWatch
RUN wget -q "https://github.com/ActivityWatch/activitywatch/releases/download/v${AW_VERSION}/activitywatch-v${AW_VERSION}-linux-x86_64.zip" \
  && unzip ./activitywatch*.zip \
  && rm ./activitywatch*.zip \
  && chmod +x ./activitywatch/aw-server-rust/aw-server-rust

# Clean up build dependencies
RUN apt-get purge -y ca-certificates unzip wget \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*

# Use /config as the single mount for all persistent data via XDG env vars
# aw-server-rust uses the xdg crate, so it respects these variables
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/config

# Expose volume and port
VOLUME /config
EXPOSE 5600

# Set shell and command
SHELL ["/bin/bash", "-c"]
# CMD ["/app/activitywatch/aw-server/aw-server", "--host", "0.0.0.0", "--cors-origins", "*"]
CMD ["/app/activitywatch/aw-server-rust/aw-server-rust", "--host", "0.0.0.0"]
