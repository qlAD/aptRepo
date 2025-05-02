#!/bin/bash

REPO_LIST="packages.list"
TMP_DIR="downloaded_packages"
mkdir -p "$TMP_DIR"

while IFS= read -r repo_url; do
  echo "处理仓库 URL: $repo_url"

  # 提取仓库所有者和仓库名称
  repo_owner=$(echo "$repo_url" | cut -d'/' -f4)
  repo_name=$(echo "$repo_url" | cut -d'/' -f5)
  
  echo "仓库所有者: $repo_owner"
  echo "仓库名称: $repo_name"

  # 获取最新发布信息
  release_url="https://api.github.com/repos/${repo_owner}/${repo_name}/releases/latest"
  echo "获取最新发布信息: $release_url"

  # 正确的正则表达式，只要包含 amd64 和 deb 就匹配
  assets=$(curl -s "$release_url" | jq -r '.assets[] | select(.name | test("amd64.*deb")) | .browser_download_url')

  if [ -z "$assets" ]; then
    echo "未找到匹配的文件，请检查仓库 URL 或网络连接。"
    continue
  fi

  # 下载每个匹配的文件
  for asset_url in $assets; do
    echo "正在下载: $asset_url"
    wget -P "$TMP_DIR" "$asset_url"
    echo "已保存到: $TMP_DIR"
  done
done < "$REPO_LIST"