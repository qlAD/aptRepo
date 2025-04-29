#!/bin/bash

REPO_DIR="gh-pages/debian"
CONF_DIR="repo-config"

# 清理旧数据
rm -rf "$REPO_DIR" "$CONF_DIR"

# 初始化配置目录
mkdir -p "$REPO_DIR"
mkdir -p "$CONF_DIR"/conf

Codename="sid"
Suite="$Codename"

# 生成核心配置文件
cat > "$CONF_DIR"/conf/distributions <<EOF
Origin: apt-repo
Label: apt-repo
Description: Self APT Repository
Codename: $Codename
Suite: $Suite
Architectures: amd64
Components: main
SignWith: yes
EOF

# 导入软件包
for deb in downloaded_packages/*.deb; do
  # 导入到仓库
  reprepro -V -b "$CONF_DIR" -S misc includedeb "$Codename" "$deb"
done

# 生成元数据
reprepro -b "$CONF_DIR" export "$Codename"

# 合并文件到发布目录
rsync -a "$CONF_DIR"/ "$REPO_DIR/"