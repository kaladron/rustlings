#!/bin/bash

# Devcontainer validation script for Rustlings
# This script tests that all required tools are available and working

set -e

echo "🦀 Validating Rustlings Devcontainer Setup..."
echo "=============================================="

# Check Rust toolchain
echo "✓ Checking Rust toolchain..."
rustc --version
cargo --version

# Check minimum Rust version (1.88+)
RUST_VERSION=$(rustc --version | sed 's/rustc \([0-9]\+\.[0-9]\+\).*/\1/')
REQUIRED_VERSION="1.88"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$RUST_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]; then 
    echo "  ✓ Rust version $RUST_VERSION meets requirement (≥ $REQUIRED_VERSION)"
else
    echo "  ✗ Rust version $RUST_VERSION does not meet requirement (≥ $REQUIRED_VERSION)"
    exit 1
fi

# Check required components
echo "✓ Checking required Rust components..."
rustup component list --installed | grep -q "clippy" && echo "  ✓ Clippy is installed"
rustup component list --installed | grep -q "rustfmt" && echo "  ✓ rustfmt is installed"

# Test clippy works
echo "✓ Testing Clippy..."
clippy-driver --version > /dev/null && echo "  ✓ Clippy is functional"

# Test rustfmt works
echo "✓ Testing rustfmt..."
rustfmt --version > /dev/null && echo "  ✓ rustfmt is functional"

# Check Git
echo "✓ Checking Git..."
git --version > /dev/null && echo "  ✓ Git is installed"

# Test basic Rust compilation
echo "✓ Testing Rust compilation..."
cd /tmp
cargo init --name test_project > /dev/null 2>&1
cd test_project
cargo check > /dev/null 2>&1 && echo "  ✓ Rust compilation works"
cd .. && rm -rf test_project

# Check if we're in the Rustlings workspace
echo "✓ Checking Rustlings workspace..."
if [ -f "/workspaces/rustlings/Cargo.toml" ]; then
    echo "  ✓ Rustlings workspace is mounted correctly"
    cd /workspaces/rustlings
    
    # Test Rustlings build
    echo "✓ Testing Rustlings build..."
    cargo check > /dev/null 2>&1 && echo "  ✓ Rustlings compiles successfully"
    
    # Test Rustlings clippy
    echo "✓ Testing Rustlings clippy..."
    cargo clippy -- --deny warnings > /dev/null 2>&1 && echo "  ✓ Rustlings passes clippy checks"
else
    echo "  ⚠ Rustlings workspace not found at expected path"
fi

echo ""
echo "🎉 Devcontainer validation completed successfully!"
echo "Ready to start learning Rust with Rustlings!"
echo ""
echo "Try running:"
echo "  cargo run -- init    # Initialize exercises"
echo "  cargo run -- watch   # Start watching for changes"