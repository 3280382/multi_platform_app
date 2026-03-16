#!/bin/bash

# ============================================================
# 🚀 Flutter 多平台应用 - 一键部署脚本
# 
# 使用方式:
#   ./DEPLOY.sh           # 使用默认版本 1.0.0
#   ./DEPLOY.sh 1.1.0     # 指定版本号
# 
# 说明: Token 已从环境变量自动读取
# ============================================================

set -e

cd "$(dirname "$0")/multi_platform_app"

# 版本号
VERSION="${1:-1.0.0}"

# 颜色
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║           🚀 Flutter 一键自动部署                          ║"
echo "║           版本: $VERSION                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# 检查 token
if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ 错误: GITHUB_TOKEN 未设置"
    echo "请检查 ~/.bashrc 或重新登录终端"
    exit 1
fi

echo -e "${GREEN}✓ GitHub Token 已加载${NC}"
echo -e "${GREEN}✓ 用户: $GITHUB_USER${NC}"
echo ""

# 执行自动部署
./AUTO_DEPLOY.sh "$VERSION"
