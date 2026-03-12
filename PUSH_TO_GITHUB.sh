#!/bin/bash
# 推送到 GitHub 并触发自动构建

echo "=== 推送到 GitHub 并触发构建 ==="
echo ""

# 读取 GitHub 用户名
echo -n "输入 GitHub 用户名: "
read USERNAME

# 初始化 git
git init
git add .
git commit -m "Initial commit: Multi-platform Flutter app"

# 添加远程仓库
git remote add origin "https://github.com/$USERNAME/multi_platform_app.git"

# 推送
git push -u origin main || git push -u origin master

# 打标签触发构建
git tag v1.0.0
git push origin v1.0.0

echo ""
echo "✅ 已推送! 访问 https://github.com/$USERNAME/multi_platform_app/actions 查看构建进度"
echo "构建完成后，在 https://github.com/$USERNAME/multi_platform_app/releases 下载"
