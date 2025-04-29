# APT Repository Management

## 项目简介

本项目用于管理和更新一个基于 Debian 的 APT 软件仓库。通过 GitHub Actions 自动化流程，定期从指定路径获取软件包，签名并构建 APT 仓库，最后将仓库部署到阿里云 OSS 和 GitHub Pages。

## 公钥获取

为了验证软件包的签名，您需要添加本仓库的公钥。

```bash
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://apt-repo.qladgk.com/public-key.asc -o /etc/apt/keyrings/qladgk.asc
sudo chmod a+r /etc/apt/keyrings/qladgk.asc
```

如果上述链接无法访问，请检查链接的合法性或稍后重试。您也可以通过以下链接手动下载：

- [https://apt-repo.qladgk.com/public-key.asc](https://apt-repoqladgk.com/public-key.asc)

## 使用方法

### 添加公钥到 APT

推荐使用 DEB822 格式 `/etc/apt/sources.list.d/xxxxx.sources` 来管理软件源

创建 `/etc/apt/sources.list.d/qladgk.sources` 文件，内容如下：

```plaintext
Types: deb
URIs: https://repos.qladgk.com/debian
Suites: sid
Components: main
Signed-By: /etc/apt/keyrings/qladgk.asc
```

### 更新并安装软件包

运行以下命令更新软件源并安装软件包：

```bash
sudo apt update
sudo apt install <package-name>
```

## 注意事项

- **密钥安全**：请确保您的 GPG 私钥和阿里云 OSS 的访问密钥安全存储，不要泄露。
- **网络问题**：如果在下载公钥或访问仓库时遇到网络问题，请检查网络连接或稍后重试。
- **依赖更新**：定期检查并更新依赖的工具和脚本，以确保兼容性和安全性。

## 联系方式

如有任何问题或建议，请通过以下邮箱联系我：

- **mail@qladgk.com**
