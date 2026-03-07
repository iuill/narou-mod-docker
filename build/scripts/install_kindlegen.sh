#!/bin/sh

set -eu

kindlegen_url="https://archive.org/download/kindlegen2.9/kindlegen_linux_2.6_i386_v2_9.tar.gz"
archive_path="/tmp/kindlegen_linux_2.6_i386_v2_9.tar.gz"
extract_dir="/tmp/kindlegen"

echo "Downloading kindlegen from: $kindlegen_url"
curl -fsSL -o "$archive_path" "$kindlegen_url"
mkdir -p "$extract_dir"
tar -xzf "$archive_path" -C "$extract_dir"
mv "$extract_dir/kindlegen" /opt/AozoraEpub3/
rm -rf "$archive_path" "$extract_dir"
