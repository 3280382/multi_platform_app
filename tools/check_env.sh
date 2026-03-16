#!/bin/bash

# Flutter 环境检查脚本
# 用法: ./check_env.sh

echo "=========================================="
echo "Flutter 多平台开发环境检查"
echo "=========================================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

check_command() {
    if command -v "$1" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $2: $(command -v $1)"
        return 0
    else
        echo -e "${RED}✗${NC} $2: 未找到"
        return 1
    fi
}

check_version() {
    echo -e "${BLUE}[$1]${NC}"
    if command -v "$2" &> /dev/null; then
        $3 2>&1 | head -2
    else
        echo "  未安装"
    fi
    echo ""
}

echo -e "${BLUE}=== 基础工具检查 ===${NC}"
echo ""

check_command git "Git"
check_command curl "cURL"
check_command wget "Wget"
check_command unzip "Unzip"
check_command zip "Zip"

echo ""
echo -e "${BLUE}=== Flutter/Dart 检查 ===${NC}"
echo ""

if check_command flutter "Flutter SDK"; then
    check_version "Flutter 版本" "flutter" "flutter --version"
fi

if check_command dart "Dart SDK"; then
    check_version "Dart 版本" "dart" "dart --version"
fi

echo -e "${BLUE}=== Java 检查 ===${NC}"
echo ""

if check_command java "Java"; then
    check_version "Java 版本" "java" "java -version"
    
    if [ -n "$JAVA_HOME" ]; then
        echo -e "${GREEN}✓${NC} JAVA_HOME: $JAVA_HOME"
    else
        echo -e "${YELLOW}⚠${NC} JAVA_HOME 未设置"
    fi
fi

echo ""
echo -e "${BLUE}=== Android 检查 ===${NC}"
echo ""

if [ -n "$ANDROID_HOME" ]; then
    echo -e "${GREEN}✓${NC} ANDROID_HOME: $ANDROID_HOME"
else
    echo -e "${YELLOW}⚠${NC} ANDROID_HOME 未设置"
fi

if [ -n "$ANDROID_SDK_ROOT" ]; then
    echo -e "${GREEN}✓${NC} ANDROID_SDK_ROOT: $ANDROID_SDK_ROOT"
else
    echo -e "${YELLOW}⚠${NC} ANDROID_SDK_ROOT 未设置"
fi

# 检查 adb
if check_command adb "Android Debug Bridge"; then
    adb version 2>&1 | head -1
fi

echo ""
echo -e "${BLUE}=== IDE/编辑器检查 ===${NC}"
echo ""

check_command code "VS Code" || true
check_command studio "Android Studio" || true

# macOS 特有检查
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo ""
    echo -e "${BLUE}=== macOS 特有检查 ===${NC}"
    echo ""
    
    check_command xcodebuild "Xcode"
    
    if [ -d "/Applications/Xcode.app" ]; then
        echo -e "${GREEN}✓${NC} Xcode 应用: /Applications/Xcode.app"
        echo "  版本: $(xcodebuild -version 2>/dev/null | head -1 || echo '无法获取')"
    fi
    
    if check_command pod "CocoaPods"; then
        pod --version
    fi
fi

# Windows 特有检查
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    echo ""
    echo -e "${BLUE}=== Windows 特有检查 ===${NC}"
    echo ""
    
    # 检查 Visual Studio
    if command -v vswhere.exe &> /dev/null || [ -d "/c/Program Files/Microsoft Visual Studio" ]; then
        echo -e "${GREEN}✓${NC} Visual Studio: 已安装"
    else
        echo -e "${YELLOW}⚠${NC} Visual Studio: 未检测到"
    fi
fi

echo ""
echo -e "${BLUE}=== Flutter Doctor ===${NC}"
echo ""

if command -v flutter &> /dev/null; then
    flutter doctor -v
else
    echo -e "${RED}Flutter 未安装，无法运行 flutter doctor${NC}"
fi

echo ""
echo "=========================================="
echo "环境检查完成"
echo "=========================================="
echo ""

# 总结
echo -e "${BLUE}=== 总结 ===${NC}"
echo ""

MISSING=0

if ! command -v flutter &> /dev/null; then
    echo -e "${RED}✗${NC} 必须: Flutter SDK"
    MISSING=$((MISSING + 1))
fi

if ! command -v java &> /dev/null; then
    echo -e "${RED}✗${NC} 必须: Java JDK (用于 Android)"
    MISSING=$((MISSING + 1))
fi

if [[ "$OSTYPE" == "darwin"* ]] && ! command -v xcodebuild &> /dev/null; then
    echo -e "${YELLOW}⚠${NC} 可选: Xcode (用于 iOS)"
fi

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    if ! command -v vswhere.exe &> /dev/null && [ ! -d "/c/Program Files/Microsoft Visual Studio" ]; then
        echo -e "${YELLOW}⚠${NC} 可选: Visual Studio (用于 Windows)"
    fi
fi

if [ $MISSING -eq 0 ]; then
    echo -e "${GREEN}✓ 基础环境已就绪${NC}"
    echo ""
    echo "可以运行以下命令:"
    echo "  cd multi_platform_app"
    echo "  flutter pub get"
    echo "  flutter run"
else
    echo ""
    echo -e "${RED}缺少 $MISSING 个必需组件${NC}"
    echo "请参考 QUICKSTART.md 进行安装"
fi

echo ""
