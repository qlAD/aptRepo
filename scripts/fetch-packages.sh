#!/bin/bash

REPO_LIST="packages.list"
DOWNLOAD_DIR="downloaded_packages"
mkdir -p "$DOWNLOAD_DIR"

while IFS= read -r url; do
  echo "正在下载: $url"
  wget -P "$DOWNLOAD_DIR" "$url"
done < "$REPO_LIST"