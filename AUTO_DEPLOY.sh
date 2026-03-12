#!/bin/bash

# ============================================================
# 全自动 GitHub 推送 + 构建 + 发布脚本
# 无需用户交互，一键完成所有操作
# ============================================================

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 配置信息（自动检测或从环境变量读取）
PROJECT_NAME="multi_platform_app"
VERSION="${1:-1.0.0}"
TAG="v${VERSION#v}"  # 确保版本号以 v 开头

# Token 可以从命令行参数、环境变量或文件读取
if [ -n "$2" ]; then
    GITHUB_TOKEN="$2"
fi

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║     🚀 Flutter 全自动部署脚本                              ║"
echo "║     版本: $VERSION                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# ============================================================
# 自动检测 GitHub 凭据
# ============================================================
echo -e "${BLUE}🔍 检测 GitHub 配置...${NC}"

# 尝试从 git config 获取用户名
GITHUB_USER=$(git config user.name 2>/dev/null || echo "")
GITHUB_EMAIL=$(git config user.email 2>/dev/null || echo "")

# 如果没有配置，使用默认值
if [ -z "$GITHUB_USER" ]; then
    GITHUB_USER="flutter-dev"
    git config user.name "$GITHUB_USER"
fi

if [ -z "$GITHUB_EMAIL" ]; then
    GITHUB_EMAIL="flutter@example.com"
    git config user.email "$GITHUB_EMAIL"
fi

# 检查 GitHub Token
if [ -z "$GITHUB_TOKEN" ]; then
    # 尝试从文件读取
    if [ -f ~/.github_token ]; then
        GITHUB_TOKEN=$(cat ~/.github_token | tr -d '\n')
    fi
fi

if [ -z "$GITHUB_TOKEN" ]; then
    echo -e "${RED}✗ 未找到 GITHUB_TOKEN${NC}"
    echo ""
    echo "请使用以下方式之一提供 Token:"
    echo ""
    echo "方式 1 - 命令行参数:"
    echo "  ./AUTO_DEPLOY.sh 1.0.0 YOUR_TOKEN"
    echo ""
    echo "方式 2 - 环境变量:"
    echo "  export GITHUB_TOKEN='your_token'"
    echo "  ./AUTO_DEPLOY.sh"
    echo ""
    echo "方式 3 - 创建文件:"
    echo "  echo 'your_token' > ~/.github_token"
    echo "  ./AUTO_DEPLOY.sh"
    echo ""
    echo "方式 4 - 运行设置脚本:"
    echo "  ../SET_GITHUB_TOKEN.sh"
    echo ""
    exit 1
fi

echo -e "${GREEN}✓ GitHub 用户: $GITHUB_USER${NC}"
echo -e "${GREEN}✓ Token 已配置${NC}"
echo ""

REPO_URL="https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${PROJECT_NAME}.git"
API_URL="https://api.github.com/repos/${GITHUB_USER}/${PROJECT_NAME}"

# ============================================================
# 创建 GitHub 仓库（如果不存在）
# ============================================================
echo -e "${BLUE}📦 检查/创建 GitHub 仓库...${NC}"

# 检查仓库是否存在
REPO_EXISTS=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: token $GITHUB_TOKEN" \
    "$API_URL")

if [ "$REPO_EXISTS" == "200" ]; then
    echo -e "${GREEN}✓ 仓库已存在: https://github.com/${GITHUB_USER}/${PROJECT_NAME}${NC}"
else
    echo "创建新仓库..."
    curl -s -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        https://api.github.com/user/repos \
        -d "{
            \"name\": \"${PROJECT_NAME}\",
            \"description\": \"Flutter multi-platform app with Android, iOS, Windows, Linux and Web support\",
            \"private\": false,
            \"has_issues\": true,
            \"has_projects\": true,
            \"has_wiki\": true
        }" > /dev/null
    
    echo -e "${GREEN}✓ 仓库创建成功${NC}"
    
    # 等待仓库创建完成
    sleep 2
fi

echo ""

# ============================================================
# 初始化 Git 仓库
# ============================================================
echo -e "${BLUE}📁 初始化 Git 仓库...${NC}"

cd "$(dirname "$0")"

if [ -d ".git" ]; then
    echo -e "${YELLOW}⚠ 检测到已有 Git 仓库，重新初始化...${NC}"
    rm -rf .git
fi

git init > /dev/null 2>&1
git config user.name "$GITHUB_USER"
git config user.email "$GITHUB_EMAIL"

echo -e "${GREEN}✓ Git 仓库初始化完成${NC}"
echo ""

# ============================================================
# 添加远程仓库
# ============================================================
echo -e "${BLUE}🔗 配置远程仓库...${NC}"

git remote remove origin 2>/dev/null || true
git remote add origin "$REPO_URL"

echo -e "${GREEN}✓ 远程仓库已配置${NC}"
echo ""

# ============================================================
# 添加并提交代码
# ============================================================
echo -e "${BLUE}📝 添加文件到 Git...${NC}"

# 添加所有文件
git add .

# 检查是否有变更要提交
if git diff --cached --quiet; then
    echo -e "${YELLOW}⚠ 没有文件变更，可能是空提交${NC}"
    # 创建一个空文件确保有变更
    echo "Last deployed: $(date)" > .last_deploy
git add .last_deploy
fi

echo -e "${GREEN}✓ 文件已添加${NC}"
echo ""

# 提交代码
echo -e "${BLUE}💾 提交代码...${NC}"
git commit -m "🚀 Release ${TAG}

Flutter Multi-Platform Application

✨ Features:
- 📱 Android APK & App Bundle support
- 🍎 iOS support (macOS build)
- 🪟 Windows desktop support
- 🐧 Linux desktop support
- 🌐 Web support
- 📐 Responsive layout (mobile/tablet/desktop)
- 🖼️ Image gallery with grid/list views
- 🔍 Search and filter functionality
- ⚙️ Settings with theme switching
- 🔗 Share functionality

🛠️ Technical Stack:
- Flutter 3.24.0
- Dart 3.0+
- Material Design 3
- go_router for navigation
- flutter_riverpod for state management
- responsive_framework for adaptive layout

📦 Build Artifacts:
- Android APK (arm64-v8a, armeabi-v7a, x86_64)
- Android AAB (Google Play)
- iOS IPA (unsigned)
- Windows EXE + DLLs
- Linux binary
- Web (HTML/JS/CSS)

🤖 CI/CD:
- GitHub Actions for all platforms
- Automated testing
- Automated release creation

Generated by Auto-Deploy Script" > /dev/null 2>&1

echo -e "${GREEN}✓ 代码已提交${NC}"
echo ""

# ============================================================
# 推送到 GitHub
# ============================================================
echo -e "${BLUE}⬆️  推送到 GitHub...${NC}"

# 强制推送到 main 分支
git branch -M main
if git push -u origin main --force; then
    echo -e "${GREEN}✓ 代码已推送到 main 分支${NC}"
else
    echo -e "${RED}✗ 推送失败${NC}"
    exit 1
fi

echo ""

# ============================================================
# 创建并推送标签（触发 GitHub Actions）
# ============================================================
echo -e "${BLUE}🏷️  创建发布标签 ${TAG}...${NC}"

# 删除本地标签（如果存在）
git tag -d "$TAG" 2>/dev/null || true

# 创建带注释的标签
git tag -a "$TAG" -m "Release ${TAG}

🎉 New Release!

📱 Platforms:
- Android (APK & AAB)
- iOS
- Windows
- Linux
- Web

📝 Changes:
- Initial release of multi-platform Flutter app
- Complete responsive UI
- Image gallery with search and filter
- Settings and theme support

🔧 Build Info:
- Flutter: 3.24.0
- Build Date: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
- Commit: $(git rev-parse --short HEAD)"

# 推送标签（这会触发 GitHub Actions）
if git push origin "$TAG" --force; then
    echo -e "${GREEN}✓ 标签已推送${NC}"
else
    echo -e "${RED}✗ 标签推送失败${NC}"
    exit 1
fi

echo ""

# ============================================================
# 等待 GitHub Actions 启动
# ============================================================
echo -e "${BLUE}⏳ 等待 GitHub Actions 启动...${NC}"

sleep 3

# 获取最新的 workflow run
RUN_INFO=$(curl -s \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "$API_URL/actions/runs?per_page=1")

RUN_ID=$(echo "$RUN_INFO" | grep -o '"id": [0-9]*' | head -1 | grep -o '[0-9]*')
RUN_URL=$(echo "$RUN_INFO" | grep -o '"html_url": "[^"]*"' | head -1 | sed 's/"html_url": "//;s/"$//')

if [ -n "$RUN_ID" ]; then
    echo -e "${GREEN}✓ GitHub Actions 已启动!${NC}"
    echo ""
    echo -e "${CYAN}构建详情:${NC}"
    echo "  Run ID: $RUN_ID"
    echo "  URL: $RUN_URL"
else
    echo -e "${YELLOW}⚠ 无法获取 workflow 信息${NC}"
fi

echo ""

# ============================================================
# 监控构建状态（可选）
# ============================================================
echo -e "${BLUE}🔍 监控构建状态...${NC}"
echo ""

echo "正在检查构建状态（每 10 秒检查一次）..."
echo "按 Ctrl+C 可以退出监控，构建会在后台继续运行"
echo ""

ATTEMPTS=0
MAX_ATTEMPTS=30  # 最多检查 5 分钟

while [ $ATTEMPTS -lt $MAX_ATTEMPTS ]; do
    STATUS_INFO=$(curl -s \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        "$API_URL/actions/runs?per_page=1")
    
    CONCLUSION=$(echo "$STATUS_INFO" | grep -o '"conclusion": "[^"]*"' | head -1 | sed 's/"conclusion": "//;s/"$//')
    STATUS=$(echo "$STATUS_INFO" | grep -o '"status": "[^"]*"' | head -1 | sed 's/"status": "//;s/"$//')
    
    if [ "$STATUS" == "completed" ]; then
        echo ""
        if [ "$CONCLUSION" == "success" ]; then
            echo -e "${GREEN}✅ 所有构建已成功完成!${NC}"
        else
            echo -e "${RED}❌ 构建失败: $CONCLUSION${NC}"
        fi
        break
    else
        echo -ne "\r⏳ 构建进行中... (状态: $STATUS, 检查次数: $((ATTEMPTS+1))/${MAX_ATTEMPTS})"
    fi
    
    ATTEMPTS=$((ATTEMPTS+1))
    sleep 10
done

echo ""
echo ""

# ============================================================
# 完成提示
# ============================================================
echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     🎉 自动部署完成!                                      ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}📦 仓库地址:${NC}"
echo "  https://github.com/${GITHUB_USER}/${PROJECT_NAME}"
echo ""
echo -e "${CYAN}🔄 构建状态:${NC}"
echo "  https://github.com/${GITHUB_USER}/${PROJECT_NAME}/actions"
echo ""
echo -e "${CYAN}📥 下载地址（构建完成后）:${NC}"
echo "  https://github.com/${GITHUB_USER}/${PROJECT_NAME}/releases/tag/${TAG}"
echo ""
echo -e "${YELLOW}⏱️ 预计构建时间:${NC}"
echo "  Android: 5-8 分钟"
echo "  iOS: 8-12 分钟"
echo "  Windows: 6-10 分钟"
echo "  Linux: 5-8 分钟"
echo "  Web: 3-5 分钟"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
