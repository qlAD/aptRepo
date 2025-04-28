#!/bin/bash

REPO_DIR="gh-pages"
CONF_DIR="repo-config"

mkdir -p $REPO_DIR/
mkdir -p $CONF_DIR/conf $CONF_DIR/incoming

cat > $CONF_DIR/conf/distributions <<EOF
Origin: qlAD's APT Repository
Label: Github Related Packages
Codename: stable
Architectures: amd64 arm64
Components: main
Description: Unofficial APT repository for Github Releases
SignWith: qlad_adgk@163.com
Suite: stable
Version: 1.0
EOF

# 导入所有 deb 包时自动检测架构
for deb in downloaded_packages/*.deb; do
  reprepro -b $CONF_DIR -C main includedeb stable "$deb"
done

# 生成 Release 文件
reprepro -b $CONF_DIR export stable

# 移动生成的文件到发布目录
mv $CONF_DIR/* $REPO_DIR/