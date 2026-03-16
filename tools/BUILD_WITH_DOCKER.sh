#!/bin/bash
# 使用 Docker 构建（无需本地 Flutter）

echo "=== 使用 Docker 构建 ==="
echo ""

cd "$(dirname "$0")"

# 构建 Docker 镜像
echo "1. 构建 Docker 镜像..."
docker-compose build

# 构建 Android
echo ""
echo "2. 构建 Android APK..."
docker-compose --profile android run --rm build-android

# 构建 Web
echo ""
echo "3. 构建 Web..."
docker-compose --profile web run --rm build-web

# 构建 Linux
echo ""
echo "4. 构建 Linux..."
docker-compose --profile linux run --rm build-linux

echo ""
echo "✅ 构建完成! 输出在 multi_platform_app/builds/ 目录"
