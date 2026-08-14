#!/bin/sh
set -eu

usage() {
    echo "Usage: $0 --version VERSION" >&2
    exit 2
}

version=""
while [ "$#" -gt 0 ]; do
    case "$1" in
        --version)
            [ "$#" -ge 2 ] || usage
            version="$2"
            shift 2
            ;;
        *)
            usage
            ;;
    esac
done

[ -n "$version" ] || usage

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
arch=$(uname -m)
case "$arch" in
    x86_64|amd64) asset_arch=x86_64 ;;
    aarch64|arm64) asset_arch=aarch64 ;;
    *)
        echo "Unsupported architecture: $arch" >&2
        exit 1
        ;;
esac

asset="dms-screenshot-rs-linux-$asset_arch"
base_url="https://github.com/hthienloc/dms-quick-capture/releases/download/$version"
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT INT TERM

curl --fail --location --silent --show-error \
    "$base_url/$asset" --output "$tmp_dir/$asset"
curl --fail --location --silent --show-error \
    "$base_url/SHA256SUMS" --output "$tmp_dir/SHA256SUMS"

(cd "$tmp_dir" && grep "  $asset\$" SHA256SUMS | sha256sum --check --status -)

mkdir -p "$repo_dir/backend/$asset_arch"
install -m 0755 "$tmp_dir/$asset" "$repo_dir/backend/$asset_arch/dms-screenshot-rs"
printf '%s\n' "$version" > "$repo_dir/backend/installed-version"

echo "Installed dms-screenshot-rs $version for $asset_arch"
