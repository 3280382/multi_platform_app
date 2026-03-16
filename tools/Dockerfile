# Flutter 多平台构建环境
# 用法:
#   docker build -t flutter-builder .
#   docker run -v $(pwd)/multi_platform_app:/app flutter-builder

FROM ubuntu:22.04

# 避免交互式配置
ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_VERSION=3.24.0
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH="${PATH}:/opt/flutter/bin:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools"

# 安装基础依赖
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-17-jdk \
    wget \
    ninja-build \
    libgtk-3-dev \
    && rm -rf /var/lib/apt/lists/*

# 安装 Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /opt/flutter \
    && flutter doctor \
    && flutter config --no-analytics

# 安装 Android SDK
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
    && cd ${ANDROID_SDK_ROOT}/cmdline-tools \
    && wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip \
    && unzip commandlinetools-linux-9477386_latest.zip \
    && mv cmdline-tools latest \
    && rm commandlinetools-linux-9477386_latest.zip

# 接受 Android 许可并安装构建工具
RUN yes | sdkmanager --licenses \
    && sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# 预下载 Flutter 依赖
RUN flutter precache --android --web

# 设置工作目录
WORKDIR /app

# 默认命令: 构建 Android
CMD ["sh", "-c", "flutter pub get && flutter build apk --release"]
