#!/bin/bash

# ============================================================
# GitHub 推送 + GitHub Actions 自动构建脚本
# ============================================================

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

PROJECT_NAME="multi_platform_app"
REPO_URL=""

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║     Flutter 多平台应用 - GitHub 自动构建发布流程          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# 检查 git
if ! command -v git &> /dev/null; then
    echo -e "${RED}✗ Git 未安装${NC}"
    echo "请先安装 Git:"
    echo "  pkg install git"
    exit 1
fi

echo -e "${GREEN}✓ Git 已安装${NC}"
echo ""

# ============================================================
# 步骤 1: GitHub 仓库设置
# ============================================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}步骤 1/4: GitHub 仓库设置${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo "请先在 GitHub 上创建仓库:"
echo ""
echo -e "${YELLOW}1. 访问:${NC} https://github.com/new"
echo ""
echo -e "${YELLOW}2. 填写信息:${NC}"
echo "   Repository name: multi_platform_app"
echo "   Description: Flutter multi-platform app with Android, iOS, Windows support"
echo "   ☑ 勾选 'Add a README file' (可选)"
echo "   ☑ 勾选 'Add .gitignore' 选择 'Dart' (可选)"
echo ""
echo -e "${YELLOW}3. 点击 'Create repository'${NC}"
echo ""

read -p "仓库创建完成后，输入您的 GitHub 用户名: " GITHUB_USER

if [ -z "$GITHUB_USER" ]; then
    echo -e "${RED}✗ 用户名不能为空${NC}"
    exit 1
fi

REPO_URL="https://github.com/$GITHUB_USER/$PROJECT_NAME.git"

echo ""
echo -e "${GREEN}✓ 仓库地址: $REPO_URL${NC}"
echo ""

# ============================================================
# 步骤 2: 初始化 Git 仓库
# ============================================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}步骤 2/4: 初始化 Git 仓库${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

cd "$(dirname "$0")"

if [ -d ".git" ]; then
    echo -e "${YELLOW}⚠ Git 仓库已存在${NC}"
    read -p "是否重新初始化? (y/n): " REINIT
    if [[ $REINIT == "y" || $REINIT == "Y" ]]; then
        rm -rf .git
        git init
        echo -e "${GREEN}✓ Git 仓库重新初始化${NC}"
    fi
else
    git init
    echo -e "${GREEN}✓ Git 仓库初始化完成${NC}"
fi

# 配置 git 用户信息（如果未配置）
if ! git config user.name &> /dev/null; then
    echo ""
    echo "配置 Git 用户信息:"
    read -p "输入您的名字: " GIT_NAME
    read -p "输入您的邮箱: " GIT_EMAIL
    git config user.name "$GIT_NAME"
    git config user.email "$GIT_EMAIL"
    echo -e "${GREEN}✓ Git 用户配置完成${NC}"
fi

echo ""

# ============================================================
# 步骤 3: 提交代码
# ============================================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}步骤 3/4: 提交代码${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 检查远程仓库
if git remote -v &> /dev/null; then
    echo -e "${YELLOW}⚠ 远程仓库已存在${NC}"
    git remote -v
    read -p "是否替换远程仓库地址? (y/n): " REPLACE_REMOTE
    if [[ $REPLACE_REMOTE == "y" || $REPLACE_REMOTE == "Y" ]]; then
        git remote remove origin 2>/dev/null || true
        git remote add origin "$REPO_URL"
        echo -e "${GREEN}✓ 远程仓库已更新${NC}"
    fi
else
    git remote add origin "$REPO_URL"
    echo -e "${GREEN}✓ 远程仓库已添加${NC}"
fi

# 添加所有文件
echo ""
echo "添加文件到 Git..."
git add .

# 检查是否有变更要提交
if git diff --cached --quiet; then
    echo -e "${YELLOW}⚠ 没有要提交的变更${NC}"
else
    # 提交
    git commit -m "🎉 Initial commit: Flutter multi-platform app

Features:
- 📱 Android & iOS support
- 🪟 Windows desktop support  
- 🌐 Web support
- 📐 Responsive layout (mobile/tablet/desktop)
- 🖼️ Image gallery with grid/list views
- ⚙️ Settings with theme switching

Includes:
- GitHub Actions CI/CD for all platforms
- Docker build support
- Complete documentation"
    
    echo -e "${GREEN}✓ 代码已提交${NC}"
fi

echo ""

# ============================================================
# 步骤 4: 推送到 GitHub
# ============================================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}步骤 4/4: 推送到 GitHub${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo "正在推送到 GitHub..."
echo ""

# 尝试推送
if git push -u origin main 2>/dev/null || git push -u origin master 2>/dev/null; then
    echo -e "${GREEN}✓ 代码已成功推送到 GitHub!${NC}"
else
    echo -e "${YELLOW}⚠ 推送失败，可能需要身份验证${NC}"
    echo ""
    echo "请尝试以下方式之一:"
    echo ""
    echo "方式 1 - 使用 Personal Access Token:"
    echo "  1. 访问: https://github.com/settings/tokens"
    echo "  2. 点击 'Generate new token (classic)'"
    echo "  3. 勾选 'repo' 权限"
    echo "  4. 生成 token 并复制"
    echo "  5. 使用: git push https://用户名:token@github.com/用户名/multi_platform_app.git"
    echo ""
    echo "方式 2 - 使用 SSH:"
    echo "  1. 生成 SSH 密钥: ssh-keygen -t ed25519 -C 'your@email.com'"
    echo "  2. 添加到 GitHub: https://github.com/settings/keys"
    echo "  3. 修改远程地址: git remote set-url origin git@github.com:$GITHUB_USER/$PROJECT_NAME.git"
    echo "  4. 重试推送"
    echo ""
    exit 1
fi

echo ""

# ============================================================
# 完成提示
# ============================================================
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🎉 代码推送成功!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${CYAN}仓库地址:${NC} $REPO_URL"
echo ""

# ============================================================
# 触发 GitHub Actions 构建
# ============================================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}触发 GitHub Actions 自动构建${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

read -p "是否立即触发构建并发布版本? (y/n): " TRIGGER_BUILD

if [[ $TRIGGER_BUILD == "y" || $TRIGGER_BUILD == "Y" ]]; then
    # 询问版本号
    read -p "输入版本号 (默认: 1.0.0): " VERSION
    VERSION=${VERSION:-"1.0.0"}
    
    # 添加 v 前缀
    if [[ $VERSION != v* ]]; then
        TAG="v$VERSION"
    else
        TAG="$VERSION"
    fi
    
    echo ""
    echo "创建标签: $TAG"
    git tag -a "$TAG" -m "Release $TAG

- Initial release of Multi-Platform Flutter App
- Android APK and App Bundle
- iOS build
- Windows executable
- Linux build
- Web build"
    
    echo "推送标签..."
    git push origin "$TAG"
    
    echo ""
    echo -e "${GREEN}✓ 标签已推送，GitHub Actions 构建已触发!${NC}"
    echo ""
    echo -e "${CYAN}构建进度:${NC} $REPO_URL/actions"
    echo ""
    echo "构建完成后，您可以在 Releases 页面下载所有平台的安装包:"
    echo -e "${CYAN}下载地址:${NC} $REPO_URL/releases"
    echo ""
    echo -e "${YELLOW}预计构建时间:${NC}"
    echo "  - Android: 5-8 分钟"
    echo "  - iOS: 8-12 分钟"
    echo "  - Windows: 6-10 分钟"
    echo "  - Linux: 5-8 分钟"
    echo "  - Web: 3-5 分钟"
    echo ""
else
    echo ""
    echo -e "${YELLOW}跳过了自动构建${NC}"
    echo ""
    echo "稍后您可以手动触发构建:"
    echo "  1. 访问: $REPO_URL/actions"
    echo "  2. 选择 'Build All Platforms'"
    echo "  3. 点击 'Run workflow'"
    echo ""
    echo "或创建标签触发:"
    echo "  git tag v1.0.0"
    echo "  git push origin v1.0.0"
    echo ""
fi

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}流程完成!${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
