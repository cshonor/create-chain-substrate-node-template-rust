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

# 构建项目
echo ""
echo "🔨 开始编译（这可能需要一些时间）..."
cargo build --release

echo ""
echo "✅ 构建完成！"
echo "📁 可执行文件位置: $PROJECT_DIR/target/release/solochain-template-node"
echo ""
echo "🚀 运行节点:"
echo "   ./target/release/solochain-template-node --dev"

