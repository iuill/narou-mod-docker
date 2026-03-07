#!/bin/sh

set -eu

version="${1:-latest}"

if [ "$version" = "latest" ]; then
    release_api_url="https://api.github.com/repos/kyukyunyorituryo/AozoraEpub3/releases/latest"
else
    release_api_url="https://api.github.com/repos/kyukyunyorituryo/AozoraEpub3/releases/tags/${version}"
fi

zip_url="$(curl -fsSL "$release_api_url" | \
    grep "browser_download_url" | \
    grep "AozoraEpub3" | \
    grep "\.zip\"$" | \
    sed -E 's/.*"browser_download_url": "(.*)".*/\1/' | \
    head -n 1)"

if [ -z "$zip_url" ]; then
    echo "Error: Could not find AozoraEpub3 zip download URL for ${version}." >&2
    exit 1
fi

echo "Downloading AozoraEpub3 from: $zip_url"
curl -fsSL -o /tmp/AozoraEpub3.zip "$zip_url"
mkdir -p /opt/AozoraEpub3
unzip /tmp/AozoraEpub3.zip -d /opt/AozoraEpub3
rm /tmp/AozoraEpub3.zip
