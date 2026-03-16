#!/bin/bash
# 本地部署脚本 - 从项目根目录运行

set -e

PROJECT_NAME=$(basename $(pwd))
echo "🚀 部署项目: $PROJECT_NAME"

# 检查 git
echo "📋 检查 Git 状态..."
git status

# 提交更改
echo "💾 提交更改..."
git add -A
git commit -m "Deploy: $(date '+%Y-%m-%d %H:%M:%S')" || echo "无更改需要提交"

# 推送
echo "📤 推送到 GitHub..."
git push origin main

# 获取最新标签
echo "🏷️  创建新版本..."
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
echo "最新标签: $LATEST_TAG"

# 解析版本号
MAJOR=$(echo $LATEST_TAG | cut -d. -f1 | tr -d 'v')
MINOR=$(echo $LATEST_TAG | cut -d. -f2)
PATCH=$(echo $LATEST_TAG | cut -d. -f3)
NEW_PATCH=$((PATCH + 1))
NEW_TAG="v${MAJOR}.${MINOR}.${NEW_PATCH}"

echo "新标签: $NEW_TAG"
git tag $NEW_TAG
git push origin $NEW_TAG

echo "✅ 已推送 $NEW_TAG"
echo "📱 CI/CD 将自动构建"
