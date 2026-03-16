#!/bin/bash

# ============================================================
# 🚀 一键部署脚本 - 全自动推送到 GitHub 并触发构建
# 
# 使用方法:
#   ./DEPLOY_NOW.sh
#   ./DEPLOY_NOW.sh 1.0.0
#   ./DEPLOY_NOW.sh 1.0.0 ghp_your_token_here
# ============================================================

set -e

cd "$(dirname "$0")"

VERSION="${1:-1.0.0}"
GITHUB_USER="$(git config user.name)"
PROJECT_NAME="multi_platform_app"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║           🚀 Flutter 多平台应用一键部署                    ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# 检查参数
if [ -z "$2" ]; then
    # 尝试从不同来源获取 token
    if [ -n "$GITHUB_TOKEN" ]; then
        TOKEN="$GITHUB_TOKEN"
        echo -e "${GREEN}✓ 从环境变量获取 Token${NC}"
    elif [ -f ~/.github_token ]; then
        TOKEN=$(cat ~/.github_token | tr -d '\n')
        echo -e "${GREEN}✓ 从 ~/.github_token 获取 Token${NC}"
    else
        echo -e "${RED}❌ 需要提供 GitHub Token${NC}"
        echo ""
        echo "请运行以下命令之一:"
        echo ""
        echo "1. 使用参数提供 Token:"
        echo -e "   ${YELLOW}./DEPLOY_NOW.sh $VERSION ghp_your_token_here${NC}"
        echo ""
        echo "2. 设置环境变量后运行:"
        echo -e "   ${YELLOW}export GITHUB_TOKEN='ghp_your_token_here'${NC}"
        echo -e "   ${YELLOW}./DEPLOY_NOW.sh $VERSION${NC}"
        echo ""
        echo "3. 创建 token 文件:"
        echo -e "   ${YELLOW}echo 'ghp_your_token_here' > ~/.github_token${NC}"
        echo -e "   ${YELLOW}./DEPLOY_NOW.sh $VERSION${NC}"
        echo ""
        echo "📖 如何获取 GitHub Token:"
        echo "   https://github.com/settings/tokens/new"
        echo "   勾选 'repo' 和 'workflow' 权限"
        echo ""
        exit 1
    fi
else
    TOKEN="$2"
    # 保存到文件以便下次使用
    echo "$TOKEN" > ~/.github_token
    chmod 600 ~/.github_token
    echo -e "${GREEN}✓ Token 已保存到 ~/.github_token${NC}"
fi

echo ""
echo -e "${CYAN}部署信息:${NC}"
echo "  版本: $VERSION"
echo "  用户: $GITHUB_USER"
echo "  项目: $PROJECT_NAME"
echo ""

# 执行部署
cd multi_platform_app
exec ./AUTO_DEPLOY.sh "$VERSION" "$TOKEN"
