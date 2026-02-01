#!/bin/bash
# WSL 运行脚本
# 在 WSL 中运行 Substrate 节点

set -e

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PROJECT_DIR"

NODE_BINARY="$PROJECT_DIR/target/release/solochain-template-node"

# 检查可执行文件是否存在
if [ ! -f "$NODE_BINARY" ]; then
    echo "❌ 错误: 节点可执行文件不存在"
    echo "请先运行: bash scripts/wsl-build.sh"
    exit 1
fi

echo "🚀 启动 Substrate 开发节点..."
echo "📁 项目目录: $PROJECT_DIR"
echo ""

# 运行节点
exec "$NODE_BINARY" --dev "$@"

