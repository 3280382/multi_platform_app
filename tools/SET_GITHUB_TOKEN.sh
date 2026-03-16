#!/bin/bash

# 设置 GitHub Token 脚本

echo "=============================================="
echo "GitHub Token 设置"
echo "=============================================="
echo ""

# 检查是否已设置
if [ -n "$GITHUB_TOKEN" ]; then
    echo "✓ GITHUB_TOKEN 已设置"
    echo "Token 前 10 位: ${GITHUB_TOKEN:0:10}..."
    echo ""
    read -p "是否重新设置? (y/n): " RESET
    if [[ $RESET != "y" && $RESET != "Y" ]]; then
        exit 0
    fi
fi

echo "请选择设置方式:"
echo ""
echo "1. 直接输入 Token"
echo "2. 从文件读取 Token"
echo "3. 创建新的 Personal Access Token"
echo ""
read -p "选择 (1-3): " CHOICE

case $CHOICE in
    1)
        echo ""
        echo "请输入 GitHub Personal Access Token:"
        echo "(输入时不会显示任何字符)"
        read -s TOKEN
        echo ""
        
        if [ -z "$TOKEN" ]; then
            echo "错误: Token 不能为空"
            exit 1
        fi
        
        # 添加到 .bashrc
        echo "" >> ~/.bashrc
        echo "# GitHub Token" >> ~/.bashrc
        echo "export GITHUB_TOKEN='$TOKEN'" >> ~/.bashrc
        
        # 立即生效
        export GITHUB_TOKEN="$TOKEN"
        
        echo "✓ Token 已设置并添加到 ~/.bashrc"
        ;;
    
    2)
        echo ""
        read -p "请输入 Token 文件路径 (默认: ~/.github_token): " TOKEN_FILE
        TOKEN_FILE=${TOKEN_FILE:-"~/.github_token"}
        TOKEN_FILE=$(eval echo $TOKEN_FILE)
        
        if [ ! -f "$TOKEN_FILE" ]; then
            echo "错误: 文件不存在: $TOKEN_FILE"
            exit 1
        fi
        
        TOKEN=$(cat "$TOKEN_FILE" | tr -d '\n')
        
        # 添加到 .bashrc
        echo "" >> ~/.bashrc
        echo "# GitHub Token" >> ~/.bashrc
        echo "export GITHUB_TOKEN='$TOKEN'" >> ~/.bashrc
        
        # 立即生效
        export GITHUB_TOKEN="$TOKEN"
        
        echo "✓ Token 已从文件读取并设置"
        ;;
    
    3)
        echo ""
        echo "请按以下步骤创建 Token:"
        echo ""
        echo "1. 访问: https://github.com/settings/tokens"
        echo ""
        echo "2. 点击 'Generate new token (classic)'"
        echo ""
        echo "3. 填写信息:"
        echo "   - Note: Flutter Build Token"
        echo "   - Expiration: 根据需要选择"
        echo "   - 勾选以下权限:"
        echo "     ☑ repo (完整仓库访问)"
        echo "     ☑ workflow (GitHub Actions)"
        echo ""
        echo "4. 点击 'Generate token' 并复制"
        echo ""
        echo "5. 粘贴 Token 到下方:"
        read -s TOKEN
        echo ""
        
        if [ -z "$TOKEN" ]; then
            echo "错误: Token 不能为空"
            exit 1
        fi
        
        # 保存到文件
        echo "$TOKEN" > ~/.github_token
        chmod 600 ~/.github_token
        
        # 添加到 .bashrc
        echo "" >> ~/.bashrc
        echo "# GitHub Token" >> ~/.bashrc
        echo "export GITHUB_TOKEN='$TOKEN'" >> ~/.bashrc
        
        # 立即生效
        export GITHUB_TOKEN="$TOKEN"
        
        echo "✓ Token 已创建并保存到 ~/.github_token"
        echo "✓ Token 已添加到 ~/.bashrc"
        ;;
    
    *)
        echo "无效的选择"
        exit 1
        ;;
esac

echo ""
echo "=============================================="
echo "设置完成!"
echo "=============================================="
echo ""
echo "Token 已生效，可以运行 AUTO_DEPLOY.sh 了"
echo ""
echo "验证命令:"
echo "  echo \$GITHUB_TOKEN"
echo ""
