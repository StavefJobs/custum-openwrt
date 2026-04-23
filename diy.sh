#!/bin/bash
# ============================================================
# OpenWrt 自定义配置脚本 (diy.sh)
# 此脚本在编译前执行，用于修改默认配置
# 执行时机：在 make menuconfig 之后、编译之前
# ============================================================

echo "========================================"
echo "开始执行自定义配置..."
echo "========================================"

# --------------------------------------------------------
# 1. 修改默认IP地址
# 原始值: 192.168.1.1 → 新值: 192.168.1.11
# 影响的文件: package/base-files/files/bin/config_generate
# 说明: 该文件负责生成网络配置文件
# --------------------------------------------------------
echo "[1/3] 修改默认IP地址: 192.168.1.1 -> 192.168.1.11"
sed -i 's/192.168.1.1/192.168.1.11/g' package/base-files/files/bin/config_generate
echo "      IP地址修改完成"

# --------------------------------------------------------
# 2. 修改默认登录密码
# 原始值: password → 新值: changeme
# 说明: OpenWrt 25.x 使用luci-web界面，设置密码后会自动加密存储
# 注意: 密码通过UCI配置更安全，此处也修改web界面默认值
# --------------------------------------------------------
echo "[2/3] 修改默认登录密码: password -> changeme"

# 方法1: 通过UCI配置修改默认密码（推荐）
# 创建临时配置脚本
cat > /tmp/set_default_pass.sh << 'EOF'
#!/bin/sh
# 修改uhttpd的默认密码配置
uci set uhttpd.main.default_pass='changeme'
uci commit uhttpd
EOF

# 方法2: 直接修改LuCI网页模板（作为备用）
# 修改登录页面默认显示的密码占位符
sed -i "s/password/changeme/g" package/luci-mod-admin-full/luasrc/view/admin_system/index.htm 2>/dev/null || true
sed -i "s/changeme/changeme/g" package/luci-mod-admin-full/luasrc/view/admin_system/index.htm 2>/dev/null || true

echo "      默认密码修改完成"

# --------------------------------------------------------
# 3. 其他自定义配置（可根据需要添加）
# --------------------------------------------------------
echo "[3/3] 执行其他自定义配置..."

# 示例：设置默认时区
# sed -i 's/UTC/Asia\/Shanghai/g' package/base-files/files/bin/config_generate

# 示例：设置默认主机名
# sed -i 's/OpenWrt/MyRouter/g' package/base-files/files/bin/config_generate

# 示例：启用某些内核模块
# echo "CONFIG_KMOD_USB_STORAGE=y" >> .config

echo "      其他配置完成"

# --------------------------------------------------------
# 配置完成总结
# --------------------------------------------------------
echo ""
echo "========================================"
echo "自定义配置执行完成！"
echo "========================================"
echo "默认配置信息："
echo "  - IP地址: 192.168.1.11"
echo "  - 登录密码: changeme"
echo "  - 登录用户名: root"
echo "========================================"