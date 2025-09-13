# Use the official Rust image as base
FROM mcr.microsoft.com/devcontainers/rust:1-1-bullseye

# Set the minimum required Rust version for Rustlings
ENV RUST_VERSION=1.88.0
ENV RUSTUP_HOME=/usr/local/rustup
ENV PATH=/usr/local/rustup/bin:$PATH

# Install the specific Rust version and required components
RUN rustup install ${RUST_VERSION} \
    && rustup default ${RUST_VERSION} \
    && rustup component add clippy rustfmt rust-src \
    && rustup --version \
    && rustc --version \
    && cargo --version \
    && cargo clippy --version

# Install additional useful tools for Rust development
RUN apt-get update && apt-get install -y \
    # Git for version control (should already be installed but ensuring it's present)
    git \
    # Build essentials for any native dependencies
    build-essential \
    # Tools for debugging and profiling
    gdb \
    valgrind \
    # Text processing tools that might be useful for Rustlings
    jq \
    tree \
    # Clean up apt cache to reduce image size
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up the workspace directory
WORKDIR /workspaces/rustlings

# Verify the installation works correctly
RUN rustc --version \
    && cargo --version \
    && clippy-driver --version \
    && rustfmt --version
