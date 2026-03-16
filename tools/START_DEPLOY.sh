#!/bin/bash
# 执行这个脚本开始部署

cd $(dirname $0)/..

# 请在此处粘贴你的 GitHub Token
# 获取地址: https://github.com/settings/tokens/new
# 需要勾选: repo 和 workflow 权限

GITHUB_TOKEN="${1:-}"

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ 请提供 GitHub Token"
    echo ""
    echo "使用方法:"
    echo "  ./START_DEPLOY.sh ghp_your_token_here"
    echo ""
    echo "如何获取 Token:"
    echo "  1. 访问 https://github.com/settings/tokens/new"
    echo "  2. Note: 填写 'Flutter Deploy'"
    echo "  3. 勾选 'repo' (完整控制仓库)"
    echo "  4. 勾选 'workflow' (GitHub Actions)"
    echo "  5. 点击 'Generate token'"
    echo "  6. 复制 token (以 ghp_ 开头)"
    echo ""
    exit 1
fi

echo "🚀 开始全自动部署..."
echo ""

# 运行部署
./DEPLOY_NOW.sh 1.0.0 "$GITHUB_TOKEN"
