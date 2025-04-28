#!/bin/bash

REPO_LIST="packages.list"
TMP_DIR="downloaded_packages"

while IFS= read -r repo_url; do
  repo_owner=$(echo "$repo_url" | cut -d'/' -f4)
  repo_name=$(echo "$repo_url" | cut -d'/' -f5)
  
  # 仅下载 amd64 架构的包
  assets=$(curl -s "https://api.github.com/repos/${repo_owner}/${repo_name}/releases/latest" | 
           jq -r '.assets[] | select(.name | test(".*_amd64\\.deb$")) | .browser_download_url')
  
  for asset_url in $assets; do
    wget -P "$TMP_DIR" "$asset_url"
  done
done < "$REPO_LIST"