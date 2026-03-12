# Multi-Platform Flutter App

一个支持 Android、iOS、Windows 的经典 Flutter 应用。

## 功能特性
- 响应式导航菜单（适配手机/平板/桌面）
- 图片浏览功能
- 信息展示页面
- 支持多种屏幕尺寸

## 运行方式

### 环境要求
- Flutter SDK 3.0+
- Android Studio / Xcode（对应平台）

### 安装依赖
```bash
flutter pub get
```

### 运行应用
```bash
# Android
flutter run -d android

# iOS（需要Mac）
flutter run -d ios

# Windows
flutter run -d windows

# Web
flutter run -d chrome
```

### 构建发布版本
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Windows
flutter build windows --release
```
