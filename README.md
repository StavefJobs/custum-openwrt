# OpenWrt 自定义编译

> 基于 OpenWrt 25.12.2 官方源码，使用 GitHub Actions 云编译

## 简介

本项目用于自动化编译 OpenWrt 固件，支持 x86_64 和 arm64 架构。

## 功能特性

- **多架构支持**：x86_64（软路由/虚拟机）、arm64（ARM开发板/盒子）
- **自定义软件源**：
  - helloworld（PassWall等科学上网插件）
  - sing-box（代理核心程序）
  - OpenWrt-nikki（透明代理插件）
- **自定义配置**：
  - 默认IP地址：192.168.1.11
  - 默认密码：changeme
  - 默认用户名：root
- **SSH调试支持**：可在编译过程中启用SSH进行问题排查

## 快速开始

### 1. Fork 仓库

点击右上角 **Fork** 按钮，复制到你的 GitHub 账户。

### 2. 配置 GitHub Secrets

在仓库设置中添加以下 Secrets：

| 名称 | 说明 | 获取方式 |
|------|------|----------|
| `GH_TOKEN` | GitHub 访问令牌 | Settings → Developer settings → Personal access tokens → Generate new token（需repo权限） |
| `SSH_PRIVATE_KEY` | SSH 私钥 | `ssh-keygen` 生成，详见下方说明 |
| `SSH_PUBLIC_KEY` | SSH 公钥 | 同上公钥内容 |

#### SSH 密钥生成

```bash
# 在本地终端执行
ssh-keygen -t ed25519 -C "github-actions@openwrt" -f ~/.ssh/openwrt_github

# 查看公钥（添加到GitHub账户）
cat ~/.ssh/openwrt_github.pub

# 查看私钥（添加到SSH_PRIVATE_KEY）
cat ~/.ssh/openwrt_github
```

### 3. 开始编译

1. 进入仓库的 **Actions** 页面
2. 选择 **Build OpenWrt** 工作流
3. 点击 **Run workflow**
4. 配置参数：
   - **Target Architecture**：选择 x86_64 或 arm64
   - **Enable SSH Debug**：可选，启用SSH调试（默认关闭）
5. 点击 **Run workflow** 开始编译

### 4. 下载固件

编译完成后（通常需要3-6小时），在 **Releases** 页面下载固件。

## 配置文件说明

```
├── .github/workflows/build-openwrt.yml  # GitHub Actions 工作流
├── feeds.conf.default                    # 自定义软件源
├── diy.sh                                # 自定义配置脚本
├── configs/
│   ├── x86_64.config                    # x86_64 编译配置
│   └── arm64.config                     # arm64 编译配置
└── README.md                             # 说明文档
```

### 修改配置文件

#### 添加自定义软件包

编辑 `feeds.conf.default`：
```bash
src-git 名称 仓库地址
```

#### 修改默认IP和密码

编辑 `diy.sh`：
```bash
# 修改IP地址
sed -i 's/192.168.1.1/192.168.1.11/g' package/base-files/files/bin/config_generate

# 修改密码
sed -i 's/changeme/你的密码/g' ...
```

#### 添加/删除编译包

编辑 `configs/x86_64.config` 或 `configs/arm64.config`：
```bash
# 添加包（在对应分类下添加）
CONFIG_PACKAGE_xxx=y

# 删除包（删除或注释掉对应行）
# CONFIG_PACKAGE_xxx=y
```

## 编译时间参考

| 架构 | 首次编译 | 后续增量编译 |
|------|----------|--------------|
| x86_64 | 3-5小时 | 30-60分钟 |
| arm64 | 4-6小时 | 40-80分钟 |

## 常见问题

### 编译失败怎么办？

1. 启用 **SSH Debug** 重新编译
2. 在编译日志中查找错误信息
3. 检查配置文件是否正确
4. 查看 [OpenWrt 官方文档](https://openwrt.org/)

### 如何查看编译进度？

在 Actions 页面点击对应的 workflow 运行记录，即可查看实时日志。

### 编译中断后如何继续？

GitHub Actions 支持断点续传，但建议在网络稳定的环境下编译。

## 致谢

- [OpenWrt 官方源码](https://github.com/openwrt/openwrt)
- [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
- [helloworld](https://github.com/fw876/helloworld)
- [sing-box](https://github.com/SagerNet/sing-box)
- [OpenWrt-nikki](https://github.com/nikkinikki-org/OpenWrt-nikki)

## License

MIT License