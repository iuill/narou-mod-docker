#!/bin/sh

set -eu

version="${1:-latest}"
repo_url="https://github.com/ponponusa/narou-mod"

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
release_page="$(curl -fsSL "${repo_url}/releases/tag/${release_tag}")"
gem_file="$(printf '%s' "$release_page" | \
    grep -o 'narou-mod-[^"[:space:]<>]*\.gem' | \
    grep -v 'mingw' | \
    head -n 1)"

if [ -z "$gem_file" ]; then
    echo "Error: Could not find narou-mod gem filename for ${version} (resolved tag: ${release_tag})." >&2
    exit 1
fi

gem_url="${repo_url}/releases/download/${release_tag}/${gem_file}"

echo "Downloading narou-mod gem from: $gem_url"
curl -fsSL -o /tmp/narou-mod.gem "$gem_url"
gem install --no-document /tmp/narou-mod.gem --install-dir "$BUNDLE_PATH"
rm /tmp/narou-mod.gem
