#!/bin/bash
# WSL 构建脚本
# 在 WSL 中构建 Substrate 节点

set -e

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PROJECT_DIR"

echo "🔨 开始构建 Substrate 节点..."
echo "📁 项目目录: $PROJECT_DIR"

# 检查 Rust 环境
if ! command -v cargo &> /dev/null; then
    echo "❌ 错误: Cargo 未安装"
    echo "请先运行: bash scripts/wsl-setup.sh"
    exit 1
fi

# 显示 Rust 版本
echo "🦀 Rust 版本: $(rustc --version)"
echo "📦 Cargo 版本: $(cargo --version)"

# 检查是否跳过 WASM 构建
SKIP_WASM=${SKIP_WASM_BUILD:-0}
USE_NIGHTLY=${USE_NIGHTLY_WASM:-0}

# 构建项目
echo ""
if [ "$SKIP_WASM" = "1" ]; then
    echo "⚠️  跳过 WASM 构建（快速模式）"
    echo "🔨 开始编译节点二进制（这可能需要一些时间）..."
    SKIP_WASM_BUILD=1 cargo build --release --bin solochain-template-node
elif [ "$USE_NIGHTLY" = "1" ] || command -v rustup &> /dev/null && rustup toolchain list | grep -q "nightly"; then
    echo "🌙 使用 nightly 工具链构建 WASM runtime"
    echo "🔨 开始编译（这可能需要一些时间）..."
    WASM_BUILD_TOOLCHAIN=nightly cargo build --release
else
    echo "🔨 开始编译（这可能需要一些时间）..."
    echo "💡 提示: 如果遇到 duplicate lang item 错误，可以："
    echo "   1. 设置 SKIP_WASM_BUILD=1 跳过 WASM 构建"
    echo "   2. 设置 USE_NIGHTLY_WASM=1 使用 nightly 工具链"
    cargo build --release || {
        echo ""
        echo "❌ 构建失败！"
        echo ""
        echo "💡 建议尝试以下方案："
        echo "   方案 1（快速）: SKIP_WASM_BUILD=1 bash scripts/wsl-build.sh"
        echo "   方案 2（完整）: USE_NIGHTLY_WASM=1 bash scripts/wsl-build.sh"
        exit 1
    }
fi

echo ""
echo "✅ 构建完成！"
echo "📁 可执行文件位置: $PROJECT_DIR/target/release/solochain-template-node"
echo ""
echo "🚀 运行节点:"
echo "   ./target/release/solochain-template-node --dev"

