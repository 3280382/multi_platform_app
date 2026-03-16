#!/bin/bash

# Flutter 多平台构建脚本
# 用法: ./build_all.sh [版本号]

set -e  # 遇到错误立即退出

VERSION=${1:-"1.0.0"}
PROJECT_DIR="multi_platform_app"
BUILD_DIR="builds"

echo "=========================================="
echo "Flutter 多平台构建脚本"
echo "版本: $VERSION"
echo "=========================================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 检查 Flutter 环境
check_flutter() {
    echo -e "${BLUE}检查 Flutter 环境...${NC}"
    
    if ! command_exists flutter; then
        echo -e "${RED}错误: Flutter 未安装${NC}"
        echo "请先安装 Flutter SDK: https://docs.flutter.dev/get-started/install"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Flutter 已安装${NC}"
    flutter --version
    echo ""
}

# 检查依赖
check_dependencies() {
    echo -e "${BLUE}检查项目依赖...${NC}"
    
    cd "$PROJECT_DIR"
    
    # 获取依赖
    echo "正在安装依赖..."
    flutter pub get
    
    # 分析代码
    echo "分析代码..."
    flutter analyze
    
    echo -e "${GREEN}✓ 依赖检查完成${NC}"
    echo ""
}

# 构建 Android
build_android() {
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${BLUE}构建 Android 版本${NC}"
    echo -e "${BLUE}==========================================${NC}"
    
    # 检查 Android SDK
    if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
        echo -e "${YELLOW}警告: Android SDK 未配置${NC}"
        echo "请设置 ANDROID_HOME 或 ANDROID_SDK_ROOT 环境变量"
    fi
    
    # 清理旧构建
    flutter clean
    
    # 构建 APK
    echo "构建 APK..."
    flutter build apk --release \
        --build-name="$VERSION" \
        --build-number=1
    
    # 构建 App Bundle
    echo "构建 App Bundle..."
    flutter build appbundle --release \
        --build-name="$VERSION" \
        --build-number=1
    
    # 复制到构建目录
    mkdir -p "../$BUILD_DIR/android"
    cp build/app/outputs/flutter-apk/app-release.apk "../$BUILD_DIR/android/multi_platform_app-$VERSION.apk"
    cp build/app/outputs/bundle/release/app-release.aab "../$BUILD_DIR/android/multi_platform_app-$VERSION.aab"
    
    echo -e "${GREEN}✓ Android 构建完成${NC}"
    echo "输出:"
    echo "  - APK: builds/android/multi_platform_app-$VERSION.apk"
    echo "  - AAB: builds/android/multi_platform_app-$VERSION.aab"
    echo ""
}

# 构建 iOS (仅限 macOS)
build_ios() {
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${BLUE}构建 iOS 版本${NC}"
    echo -e "${BLUE}==========================================${NC}"
    
    # 检查是否在 macOS 上
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo -e "${YELLOW}跳过: iOS 构建需要 macOS${NC}"
        return 0
    fi
    
    # 检查 Xcode
    if ! command_exists xcodebuild; then
        echo -e "${YELLOW}跳过: Xcode 未安装${NC}"
        return 0
    fi
    
    # 清理
    flutter clean
    
    # 构建 iOS
    echo "构建 iOS..."
    flutter build ios --release \
        --build-name="$VERSION" \
        --build-number=1 \
        --no-codesign
    
    # 复制到构建目录
    mkdir -p "../$BUILD_DIR/ios"
    
    # 创建 IPA (需要签名)
    cd build/ios/iphoneos
    mkdir -p Payload
    cp -r Runner.app Payload/
    zip -r "../../../$BUILD_DIR/ios/multi_platform_app-$VERSION.ipa" Payload
    cd ../../..
    
    echo -e "${GREEN}✓ iOS 构建完成${NC}"
    echo "输出: builds/ios/multi_platform_app-$VERSION.ipa"
    echo ""
}

# 构建 Windows
build_windows() {
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${BLUE}构建 Windows 版本${NC}"
    echo -e "${BLUE}==========================================${NC}"
    
    # 检查是否在 Windows 上
    if [[ "$OSTYPE" != "msys" && "$OSTYPE" != "cygwin" && "$OSTYPE" != "win32" ]]; then
        echo -e "${YELLOW}跳过: Windows 构建需要 Windows 系统${NC}"
        return 0
    fi
    
    # 清理
    flutter clean
    
    # 构建 Windows
    echo "构建 Windows..."
    flutter build windows --release \
        --build-name="$VERSION"
    
    # 复制到构建目录
    mkdir -p "../$BUILD_DIR/windows"
    cp -r build/windows/x64/runner/Release/* "../$BUILD_DIR/windows/"
    
    # 创建压缩包
    cd "../$BUILD_DIR/windows"
    zip -r "multi_platform_app-$VERSION-windows.zip" .
    cd "../../$PROJECT_DIR"
    
    echo -e "${GREEN}✓ Windows 构建完成${NC}"
    echo "输出: builds/windows/multi_platform_app-$VERSION-windows.zip"
    echo ""
}

# 构建 Web
build_web() {
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${BLUE}构建 Web 版本${NC}"
    echo -e "${BLUE}==========================================${NC}"
    
    # 清理
    flutter clean
    
    # 构建 Web
    echo "构建 Web..."
    flutter build web --release
    
    # 复制到构建目录
    mkdir -p "../$BUILD_DIR/web"
    cp -r build/web/* "../$BUILD_DIR/web/"
    
    # 创建压缩包
    cd "../$BUILD_DIR/web"
    zip -r "multi_platform_app-$VERSION-web.zip" .
    cd "../../$PROJECT_DIR"
    
    echo -e "${GREEN}✓ Web 构建完成${NC}"
    echo "输出: builds/web/multi_platform_app-$VERSION-web.zip"
    echo ""
}

# 构建 Linux
build_linux() {
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${BLUE}构建 Linux 版本${NC}"
    echo -e "${BLUE}==========================================${NC}"
    
    # 检查是否在 Linux 上
    if [[ "$OSTYPE" != "linux-gnu"* ]]; then
        echo -e "${YELLOW}跳过: Linux 构建需要 Linux 系统${NC}"
        return 0
    fi
    
    # 检查是否启用 Linux 桌面支持
    flutter config --enable-linux-desktop 2>/dev/null || true
    
    # 清理
    flutter clean
    
    # 构建 Linux
    echo "构建 Linux..."
    flutter build linux --release \
        --build-name="$VERSION"
    
    # 复制到构建目录
    mkdir -p "../$BUILD_DIR/linux"
    cp -r build/linux/x64/release/bundle/* "../$BUILD_DIR/linux/"
    
    # 创建压缩包
    cd "../$BUILD_DIR/linux"
    tar -czf "multi_platform_app-$VERSION-linux.tar.gz" .
    cd "../../$PROJECT_DIR"
    
    echo -e "${GREEN}✓ Linux 构建完成${NC}"
    echo "输出: builds/linux/multi_platform_app-$VERSION-linux.tar.gz"
    echo ""
}

# 生成构建报告
generate_report() {
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${BLUE}生成构建报告${NC}"
    echo -e "${BLUE}==========================================${NC}"
    
    REPORT_FILE="../$BUILD_DIR/build_report_$VERSION.txt"
    
    cat > "$REPORT_FILE" << EOF
Flutter 多平台应用构建报告
========================================
构建时间: $(date)
版本: $VERSION

构建环境:
- Flutter: $(flutter --version | head -1)
- Dart: $(dart --version 2>&1)
- 操作系统: $(uname -s -r)

构建输出:
EOF

    # 列出所有构建的文件
    cd "../$BUILD_DIR"
    find . -type f -name "*.$VERSION*" >> "$REPORT_FILE"
    cd "$PROJECT_DIR"
    
    echo -e "${GREEN}✓ 构建报告已生成: $REPORT_FILE${NC}"
    echo ""
}

# 清理构建目录
clean_builds() {
    echo -e "${BLUE}清理构建目录...${NC}"
    rm -rf "../$BUILD_DIR"
    mkdir -p "../$BUILD_DIR"
    echo -e "${GREEN}✓ 清理完成${NC}"
    echo ""
}

# 主流程
main() {
    # 检查是否在项目目录
    if [ ! -f "pubspec.yaml" ]; then
        echo -e "${RED}错误: 请在项目根目录运行此脚本${NC}"
        exit 1
    fi
    
    # 清理之前的构建
    clean_builds
    
    # 检查环境
    check_flutter
    check_dependencies
    
    # 构建各平台
    build_android
    build_ios
    build_windows
    build_linux
    build_web
    
    # 生成报告
    generate_report
    
    echo -e "${GREEN}==========================================${NC}"
    echo -e "${GREEN}所有构建完成!${NC}"
    echo -e "${GREEN}==========================================${NC}"
    echo ""
    echo "构建输出目录: $BUILD_DIR/"
    echo ""
    ls -lh "../$BUILD_DIR"/*/
}

# 处理命令行参数
case "${1:-}" in
    --help|-h)
        echo "用法: $0 [版本号]"
        echo ""
        echo "示例:"
        echo "  $0              # 使用默认版本 1.0.0"
        echo "  $0 1.2.3        # 使用指定版本 1.2.3"
        echo ""
        echo "环境要求:"
        echo "  - Flutter SDK 3.0+"
        echo "  - Android SDK (构建 Android)"
        echo "  - Xcode (构建 iOS，仅限 macOS)"
        echo "  - Visual Studio (构建 Windows)"
        exit 0
        ;;
    *)
        main
        ;;
esac
