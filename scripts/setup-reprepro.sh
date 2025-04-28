#!/bin/bash

REPO_DIR="gh-pages"
CONF_DIR="repo-config"

# 清空旧目录
rm -rf $REPO_DIR $CONF_DIR

# 初始化目录结构
mkdir -p $REPO_DIR/pool/main
mkdir -p $CONF_DIR/conf

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
EOF

# 导入软件包
for deb in downloaded_packages/*.deb; do
  # 自动获取包信息
  PKG_NAME=$(dpkg-deb -f "$deb" Package)
  SECTION=$(dpkg-deb -f "$deb" Section 2>/dev/null || echo "misc")
  ARCH=$(dpkg-deb -f "$deb" Architecture)

  # 创建标准存储路径
  POOL_PATH="pool/main/${PKG_NAME:0:1}/$PKG_NAME"
  mkdir -p $REPO_DIR/$(dirname "$POOL_PATH")
  cp "$deb" $REPO_DIR/"$POOL_PATH"

  # 导入到仓库
  case $ARCH in
    "all")
      reprepro -b $CONF_DIR -C main -S $SECTION include any-stable "$deb"
      ;;
    *)
      reprepro -b $CONF_DIR -C main -S $SECTION includedeb stable "$deb"
      ;;
  esac
done

# 生成仓库元数据
reprepro -b $CONF_DIR export stable

# 合并文件结构
rsync -a $CONF_DIR/ $REPO_DIR/