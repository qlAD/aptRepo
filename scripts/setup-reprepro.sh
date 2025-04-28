#!/bin/bash

REPO_DIR="gh-pages"
CONF_DIR="repo-config"

# 清空旧目录
rm -rf $REPO_DIR $CONF_DIR

# 初始化目录结构
mkdir -p $REPO_DIR/pool/main
mkdir -p $CONF_DIR/conf $CONF_DIR/incoming

# 生成配置文件
cat > $CONF_DIR/conf/distributions <<EOF
Origin: qlAD's APT Repository
Label: Github Related Packages
Codename: stable
Architectures: amd64 arm64
Components: main
Description: Unofficial APT repository for Github Releases
SignWith: default
Suite: stable
Version: 1.0
Default: misc
UDebComponents: main
EOF

# 导入所有 deb 包时自动检测架构
for deb in downloaded_packages/*.deb; do
  reprepro -b $CONF_DIR -C main includedeb stable "$deb"
done

# 生成 Release 文件
reprepro -b $CONF_DIR export stable

# 移动生成的文件到发布目录
mv $CONF_DIR/* $REPO_DIR/