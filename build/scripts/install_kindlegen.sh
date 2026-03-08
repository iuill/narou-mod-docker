#!/bin/sh

set -eu

kindlegen_url="https://archive.org/download/kindlegen2.9/kindlegen_linux_2.6_i386_v2_9.tar.gz"
local_archive_path="/opt/build-resources/assets/kindlegen_linux_2.6_i386_v2_9.tar.gz"
archive_path="/tmp/kindlegen_linux_2.6_i386_v2_9.tar.gz"
extract_dir="/tmp/kindlegen"

echo "Downloading kindlegen from: $kindlegen_url"
if curl -fsSL -o "$archive_path" "$kindlegen_url"; then
    echo "Downloaded kindlegen from remote archive."
elif [ -f "$local_archive_path" ]; then
    echo "Failed to download kindlegen from remote archive. Falling back to local file: $local_archive_path"
    cp "$local_archive_path" "$archive_path"
else
    echo "Error: Failed to download kindlegen and no local fallback file was found at $local_archive_path" >&2
    exit 1
fi

mkdir -p "$extract_dir"
tar -xzf "$archive_path" -C "$extract_dir"
mv "$extract_dir/kindlegen" /opt/AozoraEpub3/
rm -rf "$archive_path" "$extract_dir"
