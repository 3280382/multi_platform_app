#!/bin/bash

# ============================================================
# 快速部署脚本 - 一行命令完成所有操作
# 
# 用法:
#   ./RUN_DEPLOY.sh [版本号] [GitHub Token]
#
# 示例:
#   ./RUN_DEPLOY.sh 1.0.0 ghp_xxxxxxxxxxxx
# ============================================================

cd "$(dirname "$0")/multi_platform_app"

VERSION="${1:-1.0.0}"
TOKEN="${2:-$GITHUB_TOKEN}"

if [ -z "$TOKEN" ] && [ -f ~/.github_token ]; then
    TOKEN=$(cat ~/.github_token | tr -d '\n')
fi

if [ -z "$TOKEN" ]; then
    echo "❌ 错误: 未提供 GitHub Token"
    echo ""
    echo "使用方法:"
    echo "  ./RUN_DEPLOY.sh 1.0.0 YOUR_GITHUB_TOKEN"
    echo ""
    echo "或者先设置环境变量:"
    echo "  export GITHUB_TOKEN='your_token'"
    echo "  ./RUN_DEPLOY.sh"
    echo ""
    exit 1
fi

echo "🚀 开始部署 Flutter 多平台应用..."
echo "   版本: $VERSION"
echo "   用户: $(git config user.name)"
echo ""

# 执行自动部署
./AUTO_DEPLOY.sh "$VERSION" "$TOKEN"
