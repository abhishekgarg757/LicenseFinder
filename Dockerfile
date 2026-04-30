# syntax=docker/dockerfile:1.7
# licensefinder all-in-one image. Provides Ruby + every supported
# package manager so that `license_finder` can scan any project.
FROM ubuntu:24.04

LABEL org.opencontainers.image.title="licensefinder" \
      org.opencontainers.image.description="Audit the OSS licenses of your application's dependencies." \
      org.opencontainers.image.source="https://github.com/abhishekgarg/licensefinder" \
      org.opencontainers.image.licenses="MIT"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    TZ=Etc/UTC \
    COMPOSER_ALLOW_SUPERUSER=1

# Toolchain versions
ENV RUBY_VERSION=3.3.5 \
    NODE_MAJOR=22 \
    GO_VERSION=1.23.2 \
    GRADLE_VERSION=8.10.2 \
    SBT_VERSION=1.10.2 \
    JDK_MAJOR=21 \
    DOTNET_CHANNEL=8.0 \
    FLUTTER_VERSION=3.24.3 \
    SWIFT_VERSION=swift-5.10.1-RELEASE \
    SWIFT_BRANCH=swift-5.10.1-release \
    SWIFT_PLATFORM=ubuntu24.04 \
    CONAN_VERSION=1.66.0

WORKDIR /tmp

# ------------------------------------------------------------------
# Base OS packages
# ------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-transport-https \
        apt-utils \
        bzr \
        build-essential \
        ca-certificates \
        curl \
        git \
        gnupg2 \
        locales \
        software-properties-common \
        tzdata \
        unzip \
        wget \
        zip \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------
# Node.js (NodeSource), Yarn, pnpm, Bower
# ------------------------------------------------------------------
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g yarn pnpm bower \
    && echo '{ "allow_root": true }' > /root/.bowerrc

# ------------------------------------------------------------------
# OpenJDK 21 + Maven
# ------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        openjdk-${JDK_MAJOR}-jdk-headless \
        maven \
    && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/lib/jvm/java-${JDK_MAJOR}-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# ------------------------------------------------------------------
# Gradle
# ------------------------------------------------------------------
RUN curl -fsSL "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -o gradle.zip \
    && unzip -q gradle.zip -d /opt \
    && ln -s /opt/gradle-${GRADLE_VERSION} /opt/gradle \
    && rm gradle.zip
ENV PATH=/opt/gradle/bin:$PATH

# ------------------------------------------------------------------
# SBT
# ------------------------------------------------------------------
RUN curl -fsSL "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" -o /tmp/sbt.tgz \
    && mkdir -p /opt/sbt \
    && tar -xzf /tmp/sbt.tgz -C /opt/sbt --strip-components=1 \
    && ln -s /opt/sbt/bin/sbt /usr/local/bin/sbt \
    && rm /tmp/sbt.tgz

# ------------------------------------------------------------------
# Go
# ------------------------------------------------------------------
RUN curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz \
    && tar -C /opt -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz
ENV GOROOT=/opt/go GOPATH=/gopath PATH=/opt/go/bin:/gopath/bin:$PATH
RUN mkdir -p $GOPATH \
    && go install github.com/tools/godep@latest \
    && go install github.com/FiloSottile/gvt@latest \
    && go install github.com/kardianos/govendor@latest \
    && go clean -cache

# ------------------------------------------------------------------
# Python (Ubuntu 24.04 ships Python 3.12)
# ------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 \
        python3-dev \
        python3-pip \
        python3-venv \
        pipx \
    && rm -rf /var/lib/apt/lists/*

# pip on Noble is PEP 668 marked, install conan + pipenv with pipx
RUN pipx ensurepath \
    && pipx install --pip-args="--upgrade" "conan==${CONAN_VERSION}" \
    && pipx install pipenv
ENV PATH=/root/.local/bin:$PATH

# ------------------------------------------------------------------
# rebar3
# ------------------------------------------------------------------
RUN curl -fsSL https://s3.amazonaws.com/rebar3/rebar3 -o /usr/local/bin/rebar3 \
    && chmod +x /usr/local/bin/rebar3

# ------------------------------------------------------------------
# Erlang + Elixir
# ------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        erlang \
        elixir \
    && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------
# Rust (rustup, latest stable)
# ------------------------------------------------------------------
RUN curl -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal --default-toolchain stable
ENV PATH=/root/.cargo/bin:$PATH

# ------------------------------------------------------------------
# .NET SDK (NuGet via mono)
# ------------------------------------------------------------------
RUN curl -fsSL https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb -o /tmp/ms.deb \
    && dpkg -i /tmp/ms.deb \
    && rm /tmp/ms.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends dotnet-sdk-${DOTNET_CHANNEL} \
    && rm -rf /var/lib/apt/lists/*

# nuget.exe via mono (mono-complete may be unavailable on noble; install runtime)
RUN apt-get update && apt-get install -y --no-install-recommends mono-runtime mono-devel ca-certificates-mono \
    && curl -fsSL https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -o /usr/local/bin/nuget.exe \
    && rm -rf /var/lib/apt/lists/* || true

# ------------------------------------------------------------------
# PHP + Composer
# ------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        php-cli php-mbstring php-xml php-zip php-curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php

# ------------------------------------------------------------------
# Conda (Miniforge3 - latest)
# ------------------------------------------------------------------
RUN curl -fsSL "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh" -o miniforge.sh \
    && bash miniforge.sh -b -p /opt/conda \
    && rm miniforge.sh
ENV PATH=/opt/conda/bin:$PATH

# ------------------------------------------------------------------
# Swift Package Manager
# ------------------------------------------------------------------
ARG SWIFT_SIGNING_KEY=A62AE125BBBFBB96A6E042EC925CC1CCED3D1561
ARG SWIFT_WEBROOT=https://download.swift.org
COPY swift-all-keys.asc /tmp/swift-all-keys.asc
RUN apt-get update && apt-get install -y --no-install-recommends \
        binutils libc6-dev libcurl4-openssl-dev libedit2 \
        libpython3-dev libsqlite3-0 libxml2-dev libz3-dev \
        pkg-config tzdata zlib1g-dev libgcc-13-dev libstdc++-13-dev \
    && rm -rf /var/lib/apt/lists/* \
    && SWIFT_BIN_URL="$SWIFT_WEBROOT/$SWIFT_BRANCH/$(echo $SWIFT_PLATFORM | tr -d .)/$SWIFT_VERSION/$SWIFT_VERSION-$SWIFT_PLATFORM.tar.gz" \
    && SWIFT_SIG_URL="$SWIFT_BIN_URL.sig" \
    && export GNUPGHOME="$(mktemp -d)" \
    && (curl -fsSL "$SWIFT_BIN_URL" -o swift.tar.gz \
        && curl -fsSL "$SWIFT_SIG_URL" -o swift.tar.gz.sig \
        && gpg --import /tmp/swift-all-keys.asc \
        && gpg --batch --verify swift.tar.gz.sig swift.tar.gz \
        && tar -xzf swift.tar.gz --directory / --strip-components=1 \
        && chmod -R o+r /usr/lib/swift) \
    && rm -rf "$GNUPGHOME" swift.tar.gz swift.tar.gz.sig /tmp/swift-all-keys.asc

# ------------------------------------------------------------------
# Flutter
# ------------------------------------------------------------------
ENV FLUTTER_HOME=/opt/flutter
RUN curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" -o /tmp/flutter.tar.xz \
    && mkdir -p /opt && tar -xf /tmp/flutter.tar.xz -C /opt \
    && rm /tmp/flutter.tar.xz \
    && git config --global --add safe.directory ${FLUTTER_HOME}
ENV PATH=$PATH:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin
RUN flutter config --no-analytics \
    && flutter precache

# ------------------------------------------------------------------
# Ruby via rbenv + ruby-build
# ------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        autoconf bison libssl-dev libyaml-dev libreadline-dev \
        zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev \
        libdb-dev uuid-dev \
    && rm -rf /var/lib/apt/lists/* \
    && git clone --depth=1 https://github.com/rbenv/rbenv.git /opt/rbenv \
    && git clone --depth=1 https://github.com/rbenv/ruby-build.git /opt/rbenv/plugins/ruby-build
ENV PATH=/opt/rbenv/bin:/opt/rbenv/shims:$PATH
RUN /opt/rbenv/bin/rbenv install ${RUBY_VERSION} \
    && /opt/rbenv/bin/rbenv global ${RUBY_VERSION} \
    && /opt/rbenv/shims/gem update --system --no-document \
    && /opt/rbenv/shims/gem install --no-document bundler

# ------------------------------------------------------------------
# Trash (Rancher) - legacy Go vendoring
# ------------------------------------------------------------------
RUN curl -fsSL https://github.com/rancher/trash/releases/download/v0.2.7/trash-linux_amd64.tar.gz -o /tmp/trash.tar.gz \
    && tar -xzf /tmp/trash.tar.gz -C /usr/local/bin trash \
    && rm /tmp/trash.tar.gz

# ------------------------------------------------------------------
# Install license_finder itself
# ------------------------------------------------------------------
COPY . /licensefinder
WORKDIR /licensefinder
RUN bash -lc "bundle config set no-cache 'true' && bundle install -j4 && bundle pristine && rake install"

WORKDIR /
CMD ["/bin/bash", "-l", "-c", "cd /scan && /bin/bash -l"]
