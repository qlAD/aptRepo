#!/bin/bash

REPO_LIST="packages.list"
DOWNLOAD_DIR="downloaded_packages"
mkdir -p "$DOWNLOAD_DIR"

# 使用 while 循环逐行读取文件
while IFS= read -r url || [ -n "$url" ]; do
  echo "读取到的 URL: $url"
  if [ -z "$url" ]; then
    echo "跳过空行"
    continue
  fi
  echo "正在下载: $url"
  wget -P "$DOWNLOAD_DIR" "$url"
done < "$REPO_LIST"

echo "所有下载任务完成"
