#!/bin/bash
# WSL 环境设置脚本
# 用于在 WSL (Ubuntu) 中设置 Substrate 开发环境

set -e

echo "🚀 开始设置 WSL 开发环境..."

# 更新系统包
echo "📦 更新系统包..."
sudo apt update || {
    echo "❌ apt update 失败，请检查网络连接和权限"
    exit 1
}

# 安装必要的依赖
echo "📦 安装构建依赖..."
sudo apt install -y \
    git \
    clang \
    curl \
    libssl-dev \
    llvm \
    libudev-dev \
    build-essential \
    protobuf-compiler || {
    echo "❌ 依赖安装失败，请检查权限"
    exit 1
}

# 安装 Rust
if ! command -v rustc &> /dev/null; then
    echo "🦀 安装 Rust 工具链..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.cargo/env
else
    echo "✅ Rust 已安装: $(rustc --version)"
fi

# 配置 Rust 工具链
echo "🔧 配置 Rust 工具链..."
source ~/.cargo/env
rustup default stable
rustup update
rustup target add wasm32-unknown-unknown

# 可选：安装 nightly 工具链（用于 WASM 构建，解决 duplicate lang item 问题）
echo ""
read -p "是否安装 nightly 工具链用于 WASM 构建？(y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🌙 安装 nightly 工具链..."
    rustup toolchain install nightly
    rustup target add wasm32-unknown-unknown --toolchain nightly
    echo "✅ nightly 工具链已安装"
    echo "💡 使用方式: USE_NIGHTLY_WASM=1 bash scripts/wsl-build.sh"
fi

# 显示版本信息
echo ""
echo "✅ 环境设置完成！"
echo "📋 版本信息："
rustc --version
cargo --version
rustup target list --installed | grep wasm32-unknown-unknown || echo "⚠️  wasm32-unknown-unknown 目标未安装"

echo ""
echo "🎯 下一步："
echo "   1. 将项目复制到 WSL Linux 文件系统（推荐）："
echo "      cp -r /mnt/c/Users/12392/Desktop/node\\ template/my-node-template ~/my-node-template"
echo "      cd ~/my-node-template"
echo ""
echo "   2. 或者直接在 Linux 文件系统中克隆："
echo "      cd ~"
echo "      git clone <your-repo-url> my-node-template"
echo "      cd my-node-template"
echo ""
echo "   3. 构建项目："
echo "      cargo build --release"
echo ""
echo "   4. 运行节点："
echo "      ./target/release/solochain-template-node --dev"

