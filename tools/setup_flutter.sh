#!/bin/bash

# Flutter 环境设置脚本
# 此脚本帮助在支持的系统上安装 Flutter SDK

echo "=========================================="
echo "Flutter 多平台开发环境设置脚本"
echo "=========================================="
echo ""

# 检测操作系统
OS="$(uname -s)"
ARCH="$(uname -m)"

echo "检测到系统: $OS $ARCH"
echo ""

# 检查是否已安装 Flutter
if command -v flutter &> /dev/null; then
    echo "✓ Flutter 已安装"
    flutter --version
    echo ""
    read -p "是否重新安装 Flutter? (y/n): " reinstall
    if [[ $reinstall != "y" && $reinstall != "Y" ]]; then
        echo "跳过 Flutter 安装"
    else
        echo "将继续安装..."
    fi
else
    echo "✗ Flutter 未安装"
    echo ""
fi

# 安装指南
echo "=========================================="
echo "Flutter 安装指南"
echo "=========================================="
echo ""

case "$OS" in
    Linux*)
        if [[ "$ARCH" == "x86_64" ]]; then
            echo "📥 下载 Linux x64 版本:"
            echo "   https://docs.flutter.dev/get-started/install/linux"
            echo ""
            echo "安装步骤:"
            echo "1. 下载 Flutter SDK"
            echo "   wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz"
            echo ""
            echo "2. 解压到 ~/flutter"
            echo "   tar -xf flutter_linux_3.24.5-stable.tar.xz"
            echo ""
            echo "3. 添加环境变量到 ~/.bashrc"
            echo "   export PATH=\"\$HOME/flutter/bin:\$PATH\""
            echo ""
        else
            echo "⚠️  您的架构 ($ARCH) 可能需要特殊配置"
            echo "建议使用 Git 方式安装:"
            echo "   git clone https://github.com/flutter/flutter.git -b stable"
        fi
        ;;
    Darwin*)
        echo "📥 macOS 安装选项:"
        echo ""
        echo "选项 1 - 使用 Homebrew:"
        echo "   brew install flutter"
        echo ""
        echo "选项 2 - 手动安装:"
        echo "   https://docs.flutter.dev/get-started/install/macos"
        echo ""
        ;;
    CYGWIN*|MINGW*|MSYS*)
        echo "📥 Windows 安装:"
        echo ""
        echo "1. 下载 Flutter SDK:"
        echo "   https://docs.flutter.dev/get-started/install/windows"
        echo ""
        echo "2. 解压到 C:\flutter"
        echo ""
        echo "3. 添加环境变量:"
        echo "   C:\flutter\bin"
        echo ""
        ;;
    *)
        echo "⚠️  未识别的操作系统"
        ;;
esac

echo "=========================================="
echo "项目运行指南"
echo "=========================================="
echo ""
echo "1. 进入项目目录:"
echo "   cd multi_platform_app"
echo ""
echo "2. 安装依赖:"
echo "   flutter pub get"
echo ""
echo "3. 运行应用:"
echo "   # Android"
echo "   flutter run -d android"
echo ""
echo "   # iOS (仅限 Mac)"
echo "   flutter run -d ios"
echo ""
echo "   # Windows"
echo "   flutter run -d windows"
echo ""
echo "   # Web"
echo "   flutter run -d chrome"
echo ""
echo "4. 构建发布版本:"
echo "   # Android APK"
echo "   flutter build apk --release"
echo ""
echo "   # Android App Bundle"
echo "   flutter build appbundle --release"
echo ""
echo "   # iOS"
echo "   flutter build ios --release"
echo ""
echo "   # Windows"
echo "   flutter build windows --release"
echo ""
echo "=========================================="
echo "平台特定要求"
echo "=========================================="
echo ""
echo "📱 Android:"
echo "   - Android Studio"
echo "   - Android SDK"
echo "   - Android 模拟器或真机"
echo ""
echo "🍎 iOS (仅限 macOS):"
echo "   - Xcode"
echo "   - iOS 模拟器或真机"
echo "   - Apple Developer 账号（发布需要）"
echo ""
echo "🪟 Windows:"
echo "   - Visual Studio 2022 (Windows 开发)"
echo "   - Windows 10 或更高版本"
echo ""
echo "=========================================="
echo "项目结构"
echo "=========================================="
echo ""
tree -L 2 multi_platform_app 2>/dev/null || find multi_platform_app -maxdepth 2 -type d | head -20
echo ""
