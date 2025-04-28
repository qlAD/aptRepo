#!/bin/bash
set -ex

REPO_DIR="gh-pages"
CONF_DIR="repo-config"

# 清理旧数据
rm -rf "$REPO_DIR" "$CONF_DIR"

# 初始化目录结构
mkdir -p "$REPO_DIR"/{dists/stable/main/binary-amd64,pool/main}
mkdir -p "$CONF_DIR"/{conf,incoming}

# 生成核心配置文件
cat > "$CONF_DIR"/conf/distributions <<'EOF'
Origin: qlAD's APT Repository
Label: Github Related Packages
Codename: stable
Architectures: amd64
Components: main
Description: Unofficial APT repository for Github Releases
SignWith: default
Suite: stable
Version: 1.0
EOF

# 导入软件包
for deb in downloaded_packages/*.deb; do
  # 获取包元数据
  PKG_NAME=$(dpkg-deb -f "$deb" Package)
  PKG_SECTION=$(dpkg-deb -f "$deb" Section 2>/dev/null || echo "misc")

  # 创建符合 Debian 标准的存储路径
  POOL_DIR="$REPO_DIR/pool/main/${PKG_NAME:0:1}/$PKG_NAME"
  mkdir -p "$POOL_DIR"
  cp "$deb" "$POOL_DIR/"

  # 导入到仓库
  reprepro -b "$CONF_DIR" -C main -A amd64 -S "$PKG_SECTION" includedeb stable "$deb"
done

# 生成元数据
reprepro -b "$CONF_DIR" export stable

# 合并文件到发布目录
rsync -a "$CONF_DIR"/ "$REPO_DIR/"