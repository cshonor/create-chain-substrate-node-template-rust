# Node 目录详解

## 概述

`node/` 目录包含 **Substrate 节点的客户端实现**，这是区块链的"外壳"部分，负责运行和管理区块链节点。

## Node vs Runtime 的区别

```
┌─────────────────────────────────────────┐
│          Substrate 区块链                │
├─────────────────────────────────────────┤
│  Node (节点客户端)                       │
│  - 网络通信                              │
│  - 共识机制                              │
│  - 交易池管理                            │
│  - RPC 服务                              │
│  - CLI 命令行接口                        │
│  - 数据库管理                            │
├─────────────────────────────────────────┤
│  Runtime (运行时逻辑)                    │
│  - 业务逻辑 (Pallets)                    │
│  - 状态转换                              │
│  - 执行交易                              │
└─────────────────────────────────────────┘
```

**简单理解：**
- **Node** = 区块链的"操作系统"（管理、通信、存储）
- **Runtime** = 区块链的"应用程序"（业务逻辑、状态管理）

## Node 目录结构

```
node/
├── Cargo.toml          # 节点依赖配置
├── build.rs            # 构建脚本
└── src/
    ├── main.rs         # 程序入口点
    ├── command.rs      # CLI 命令处理
    ├── cli.rs          # 命令行接口定义
    ├── service.rs      # 节点服务实现
    ├── chain_spec.rs   # 链规格配置
    ├── rpc.rs          # RPC 服务配置
    └── benchmarking.rs # 基准测试
```

## 核心文件说明

### 1. `main.rs` - 程序入口

```rust
fn main() -> sc_cli::Result<()> {
    command::run()
}
```

**作用：**
- 程序的入口点
- 调用命令处理模块

### 2. `cli.rs` - 命令行接口

**作用：**
- 定义节点的命令行参数
- 处理用户输入的命令

**常见命令：**
- `--dev` - 开发模式
- `--chain` - 指定链配置
- `--name` - 节点名称
- `--validator` - 验证者模式
- `--base-path` - 数据存储路径

### 3. `command.rs` - 命令处理

**作用：**
- 解析和执行 CLI 命令
- 调用相应的服务功能

**主要功能：**
- 运行节点
- 构建链规格
- 基准测试
- 密钥管理

### 4. `service.rs` - 节点服务核心

**作用：**
- 初始化和管理节点服务
- 配置共识机制（Aura、GRANDPA）
- 设置网络层
- 配置交易池
- 启动 RPC 服务

**关键组件：**

```rust
// 客户端（与 Runtime 交互）
pub(crate) type FullClient = sc_service::TFullClient<...>;

// 服务组件
pub type Service = sc_service::PartialComponents<...>;

// 创建服务
pub fn new_partial(config: &Configuration) -> Result<Service, ServiceError> {
    // 初始化各种组件...
}
```

**主要功能：**
1. **客户端初始化**：创建与 Runtime 交互的客户端
2. **共识配置**：设置 Aura（区块生产）和 GRANDPA（最终性）
3. **网络层**：配置 P2P 网络通信
4. **交易池**：管理待处理的交易
5. **RPC 服务**：提供 JSON-RPC API

### 5. `chain_spec.rs` - 链规格配置

**作用：**
- 定义链的初始状态（Genesis）
- 配置开发链和测试链

**示例：**

```rust
// 开发链配置
pub fn development_chain_spec() -> Result<ChainSpec, String> {
    Ok(ChainSpec::builder(...)
        .with_name("Development")
        .with_id("dev")
        .with_chain_type(ChainType::Development)
        .build())
}
```

**包含的信息：**
- 链名称和 ID
- 初始账户和余额
- 验证者列表
- 链类型（开发/测试/生产）

### 6. `rpc.rs` - RPC 服务配置

**作用：**
- 配置 JSON-RPC API
- 注册 RPC 方法

**提供的 API：**
- 查询链状态
- 发送交易
- 订阅事件
- 查询账户信息

### 7. `benchmarking.rs` - 基准测试

**作用：**
- 性能基准测试
- 测量 Pallet 执行时间
- 用于设置交易权重

## Node 的主要职责

### 1. 网络通信

- **P2P 网络**：与其他节点通信
- **区块同步**：下载和验证区块
- **交易传播**：广播和接收交易

### 2. 共识机制

- **Aura**：区块生产（谁可以生产区块）
- **GRANDPA**：最终确定性（何时区块最终确定）

### 3. 交易处理

- **交易池**：管理待处理的交易
- **交易验证**：验证交易的有效性
- **交易执行**：调用 Runtime 执行交易

### 4. 数据存储

- **区块链数据**：存储所有区块
- **状态数据**：存储当前链状态
- **索引**：快速查询数据

### 5. API 服务

- **JSON-RPC**：提供 HTTP/WebSocket API
- **命令行接口**：提供 CLI 命令

## Node 与 Runtime 的交互

```
用户/应用
    ↓
Node (客户端)
    ↓ (调用)
Runtime (运行时)
    ↓ (执行)
Pallets (业务逻辑)
    ↓ (更新)
链状态
```

**交互流程：**

1. **用户发送交易** → Node 接收
2. **Node 验证交易** → 检查签名、格式等
3. **Node 调用 Runtime** → 执行交易逻辑
4. **Runtime 执行 Pallets** → 更新状态
5. **Node 存储结果** → 保存到数据库
6. **Node 广播区块** → 通知其他节点

## 关键依赖

### Substrate Client (`sc-*`)

- `sc-service` - 节点服务框架
- `sc-client-api` - 客户端 API
- `sc-network` - 网络层
- `sc-consensus` - 共识机制
- `sc-transaction-pool` - 交易池

### Substrate Primitives (`sp-*`)

- `sp-core` - 核心类型
- `sp-runtime` - 运行时接口
- `sp-api` - Runtime API

### Runtime

- `solochain-template-runtime` - 项目的运行时（在 `runtime/` 目录）

## 如何修改 Node

### 添加新的 CLI 命令

1. 在 `cli.rs` 中定义命令参数
2. 在 `command.rs` 中实现命令处理逻辑

### 修改 RPC API

1. 在 `rpc.rs` 中添加新的 RPC 方法
2. 实现相应的处理逻辑

### 修改共识机制

1. 在 `service.rs` 中修改共识配置
2. 调整 Aura 或 GRANDPA 参数

### 添加新的链规格

1. 在 `chain_spec.rs` 中添加新的链配置函数
2. 在 `cli.rs` 中注册新的链类型

## 常见使用场景

### 1. 开发模式运行

```bash
./target/release/solochain-template-node --dev
```

### 2. 自定义链运行

```bash
./target/release/solochain-template-node \
    --chain custom-chain-spec.json \
    --name MyNode
```

### 3. 验证者模式

```bash
./target/release/solochain-template-node \
    --validator \
    --key <validator-key>
```

### 4. 连接到远程节点

```bash
./target/release/solochain-template-node \
    --chain <chain-spec> \
    --bootnodes /ip4/<ip>/tcp/<port>/p2p/<peer-id>
```

## 总结

**`node/` 目录是：**
- ✅ 区块链节点的客户端实现
- ✅ 负责网络、共识、存储、API
- ✅ 与 Runtime 交互的桥梁
- ✅ 用户与区块链交互的接口

**主要特点：**
- 使用 Substrate 客户端框架 (`sc-*`)
- 可配置和可扩展
- 支持多种运行模式
- 提供丰富的 CLI 和 RPC API

**开发建议：**
- 大多数情况下不需要修改 Node 代码
- 主要开发工作在 Runtime 和 Pallets
- 只有在需要自定义节点行为时才修改 Node

## 相关文档

- [Substrate Node 架构](https://docs.substrate.io/fundamentals/node-architecture/)
- [Substrate Service 文档](https://docs.rs/substrate/latest/substrate/service/index.html)
- [CLI 开发指南](https://docs.substrate.io/reference/command-line-tools/)

