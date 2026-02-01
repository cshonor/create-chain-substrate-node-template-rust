#!/bin/bash
# WSL 项目迁移脚本
# 将项目从 Windows 文件系统复制到 WSL Linux 文件系统（性能更好）

set -e

# Windows 文件系统路径
WINDOWS_PATH="/mnt/c/Users/12392/Desktop/node template/my-node-template"

# Linux 文件系统目标路径
LINUX_PATH="$HOME/my-node-template"

echo "📦 将项目从 Windows 文件系统迁移到 WSL Linux 文件系统..."
echo ""
echo "源路径: $WINDOWS_PATH"
echo "目标路径: $LINUX_PATH"
echo ""

# 检查源路径是否存在
if [ ! -d "$WINDOWS_PATH" ]; then
    echo "❌ 错误: 源路径不存在: $WINDOWS_PATH"
    echo "请检查路径是否正确"
    exit 1
fi

# 如果目标路径已存在，询问是否覆盖
if [ -d "$LINUX_PATH" ]; then
    echo "⚠️  目标路径已存在: $LINUX_PATH"
    read -p "是否覆盖？(y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ 操作已取消"
        exit 1
    fi
    echo "🗑️  删除现有目录..."
    rm -rf "$LINUX_PATH"
fi

# 复制项目
echo "📋 复制项目文件..."
cp -r "$WINDOWS_PATH" "$LINUX_PATH"

# 清理 Windows 特定的文件（如果有）
cd "$LINUX_PATH"
echo "🧹 清理临时文件..."

# 显示结果
echo ""
echo "✅ 项目已成功迁移到: $LINUX_PATH"
echo ""
echo "🎯 下一步："
echo "   cd ~/my-node-template"
echo "   bash scripts/wsl-setup.sh    # 首次运行：设置环境"
echo "   bash scripts/wsl-build.sh    # 构建项目"
echo "   bash scripts/wsl-run.sh       # 运行节点"
echo ""
echo "💡 提示：在 Linux 文件系统中编译速度会快很多！"

