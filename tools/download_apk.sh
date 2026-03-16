#!/bin/bash
echo "📥 下载 Android APK..."
echo ""
echo "运行ID: 22996689716"
echo ""
echo "方法1 - 使用GitHub CLI:"
echo "  gh run download 22996689716 --name android-apk --repo 3280382/multi_platform_app"
echo ""
echo "方法2 - 浏览器下载:"
echo "  https://github.com/3280382/multi_platform_app/actions/runs/22996689716"
echo ""
echo "方法3 - 手动复制链接下载:"
TOKEN=$(cat ~/.config/gh/hosts.yml 2>/dev/null | grep "oauth_token:" | head -1 | sed 's/.*oauth_token: //')
if [ -n "$TOKEN" ]; then
    echo "正在获取下载链接..."
    URL=$(curl -s -H "Authorization: token $TOKEN" \
      "https://api.github.com/repos/3280382/multi_platform_app/actions/runs/22996689716/artifacts" | \
      python3 -c "import json,sys; arts=json.load(sys.stdin).get('artifacts',[]); apk=[a for a in arts if 'apk' in a['name'].lower()]; print(apk[0]['archive_download_url'] if apk else '未找到')")
    echo "下载URL: $URL"
    if [ "$URL" != "未找到" ] && [ -n "$URL" ]; then
        echo ""
        echo "直接下载命令:"
        echo "curl -L -H \"Authorization: token ${TOKEN:0:10}...\" \"$URL\" -o android-apk.zip"
    fi
fi
