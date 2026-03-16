# Multi Platform App

Flutter 多平台应用模板项目。

## 快速开始

```bash
# 本地开发
flutter run

# 本地部署（推送到 GitHub 触发 CI/CD）
./tools/local_deploy.sh

# 或使用 Git 命令手动部署
git add -A
git commit -m "更新说明"
git push origin main
git tag v1.x.x
git push origin v1.x.x
```

## 项目结构

```
.
├── android/          # Android 配置
├── ios/              # iOS 配置
├── lib/              # Dart 代码
├── web/              # Web 配置
├── windows/          # Windows 配置
├── linux/            # Linux 配置
├── macos/            # macOS 配置
├── tools/            # 部署和构建脚本
└── .github/workflows/# CI/CD 配置
```

## CI/CD

推送到 `main` 分支或创建标签会自动触发 GitHub Actions 构建所有平台。

## 仓库

https://github.com/3280382/multi_platform_app
