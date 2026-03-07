#!/bin/sh

set -eu

version="${1:-latest}"

if [ "$version" = "latest" ]; then
    release_api_url="https://api.github.com/repos/ponponusa/narou-mod/releases/latest"
else
    release_api_url="https://api.github.com/repos/ponponusa/narou-mod/releases/tags/${version}"
fi

gem_url="$(curl -fsSL "$release_api_url" | \
    grep "browser_download_url" | \
    grep "\.gem\"$" | \
    grep -v "mingw" | \
    sed -E 's/.*"browser_download_url": "(.*)".*/\1/' | \
    head -n 1)"

if [ -z "$gem_url" ]; then
    echo "Error: Could not find narou-mod gem download URL for ${version}." >&2
    exit 1
fi

echo "Downloading narou-mod gem from: $gem_url"
curl -fsSL -o /tmp/narou-mod.gem "$gem_url"
gem install --no-document /tmp/narou-mod.gem --install-dir "$BUNDLE_PATH"
rm /tmp/narou-mod.gem
