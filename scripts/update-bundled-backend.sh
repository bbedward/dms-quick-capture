#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
manifest="$repo_dir/dms-screenshot-rs/Cargo.toml"
arch=$(uname -m)

case "$arch" in
    x86_64|amd64) bundle_arch=x86_64 ;;
    aarch64|arm64) bundle_arch=aarch64 ;;
    *)
        echo "Unsupported architecture: $arch" >&2
        exit 1
        ;;
esac

cargo build --release --manifest-path "$manifest"
mkdir -p "$repo_dir/backend/$bundle_arch"
cp "$repo_dir/dms-screenshot-rs/target/release/dms-screenshot-rs" \
    "$repo_dir/backend/$bundle_arch/dms-screenshot-rs"
chmod +x "$repo_dir/backend/$bundle_arch/dms-screenshot-rs"

echo "Updated backend/$bundle_arch/dms-screenshot-rs"
