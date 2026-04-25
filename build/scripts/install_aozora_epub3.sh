#!/bin/sh

set -eu

version="${1:-latest}"
repo_url="https://github.com/kyukyunyorituryo/AozoraEpub3"

resolve_release_tag() {
    requested_version="$1"

    if [ "$requested_version" = "latest" ]; then
        curl -fsSIL -o /dev/null -w '%{url_effective}' "${repo_url}/releases/latest" | \
            sed -E 's#^.*/tag/([^/?#]+).*$#\1#'
        return
    fi

    printf '%s\n' "$requested_version"
}

release_tag="$(resolve_release_tag "$version")"
expanded_assets_page="$(curl -fsSL "${repo_url}/releases/expanded_assets/${release_tag}")"
zip_file="$(printf '%s' "$expanded_assets_page" | \
    grep -o 'AozoraEpub3[^"[:space:]<>]*\.zip' | \
    grep -v '/releases/download/' | \
    grep -v '/archive/' | \
    head -n 1)"

if [ -z "$zip_file" ]; then
    echo "Error: Could not find AozoraEpub3 zip filename for ${version} (resolved tag: ${release_tag})." >&2
    exit 1
fi

zip_url="${repo_url}/releases/download/${release_tag}/${zip_file}"

echo "Downloading AozoraEpub3 from: $zip_url"
curl -fsSL -o /tmp/AozoraEpub3.zip "$zip_url"
mkdir -p /opt/AozoraEpub3
unzip /tmp/AozoraEpub3.zip -d /opt/AozoraEpub3
rm /tmp/AozoraEpub3.zip
