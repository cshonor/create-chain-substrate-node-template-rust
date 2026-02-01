# Substrate Node Template

A fresh [Substrate](https://substrate.io/) node, ready for hacking :rocket:

A standalone version of this template is available for each release of Polkadot
in the [Substrate Developer Hub Parachain
Template](https://github.com/substrate-developer-hub/substrate-node-template/)
repository. The parachain template is generated directly at each Polkadot
release branch from the [Solochain Template in
Substrate](https://github.com/paritytech/polkadot-sdk/tree/master/templates/solochain)
upstream

It is usually best to use the stand-alone version to start a new project. All
bugs, suggestions, and feature requests should be made upstream in the
[Substrate](https://github.com/paritytech/polkadot-sdk/tree/master/substrate)
repository.

## Getting Started

Depending on your operating system and Rust version, there might be additional
packages required to compile this template. Check the
[Install](https://docs.substrate.io/install/) instructions for your platform for
the most common dependencies. Alternatively, you can use one of the [alternative
installation](#alternatives-installations) options.

### 构建环境选择

#### Windows 开发环境（推荐使用 WSL）

**⚠️ 重要提示：** Substrate 在 Windows 原生环境下的开发支持并不完善！强烈建议使用 [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)，并按照 Ubuntu/Debian 的说明进行操作。

**在 WSL 中构建的步骤：**

1. 安装 WSL 和 Ubuntu（如果尚未安装）：
   ```powershell
   wsl --install
   ```

2. **重要：将项目迁移到 WSL Linux 文件系统**（⚠️ 必须，性能要求）：
   
   **方式一：使用迁移脚本（推荐）**
   ```bash
   # 在 WSL 中运行
   cd /mnt/c/Users/12392/Desktop/node\ template/my-node-template
   bash scripts/wsl-migrate.sh
   cd ~/my-node-template
   ```
   
   **方式二：手动复制**
   ```bash
   # 将项目从 Windows 文件系统复制到 Linux 文件系统
   cp -r /mnt/c/Users/12392/Desktop/node\ template/my-node-template ~/my-node-template
   cd ~/my-node-template
   ```
   
   **方式三：直接在 Linux 文件系统中克隆**
   ```bash
   cd ~
   git clone https://github.com/cshonor/create-chain-substrate-node-template-rust.git my-node-template
   cd my-node-template
   ```
   
   ⚠️ **为什么必须在 Linux 文件系统中？**
   - Windows 文件系统（`/mnt/c/`）上的编译速度会慢 **10-100 倍**
   - 可能遇到文件权限和路径问题
   - Linux 文件系统（`~/`）提供原生性能

3. 设置开发环境（使用提供的脚本）：
   ```bash
   # 将项目从 Windows 文件系统复制到 Linux 文件系统
   cp -r /mnt/c/Users/12392/Desktop/node\ template/my-node-template ~/my-node-template
   cd ~/my-node-template
   
   # 或者直接在 Linux 文件系统中克隆
   cd ~
   git clone https://github.com/cshonor/create-chain-substrate-node-template-rust.git my-node-template
   cd my-node-template
   ```

5. 设置开发环境并运行：
   ```bash
   # 首次运行：设置开发环境（安装 Rust 和依赖）
   bash scripts/wsl-setup.sh
   
   # 构建项目
   bash scripts/wsl-build.sh
   
   # 运行节点
   bash scripts/wsl-run.sh
   ```

   或者手动执行：
   ```bash
   # 设置环境（仅首次需要）
   sudo apt update
   sudo apt install -y git clang curl libssl-dev llvm libudev-dev build-essential protobuf-compiler
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   source ~/.cargo/env
   rustup default stable
   rustup target add wasm32-unknown-unknown
   
   # 构建和运行
   cargo build --release
   ./target/release/solochain-template-node --dev
   ```

**⚠️ 性能提示：** 在 Windows 文件系统（`/mnt/c/...`）上编译 Rust 项目会非常慢。强烈建议将项目复制到 WSL 的 Linux 文件系统（`~/` 或 `/home/username/`）中进行开发。

#### 云服务器部署（DigitalOcean / AWS / 等）

对于生产环境部署或需要 24/7 运行的节点，建议使用云服务器：

**推荐配置：**
- **操作系统：** Ubuntu 22.04 LTS 或更高版本
- **资源要求：** 最低 4GB 内存，2 个 CPU 核心（生产环境建议 8GB+）
- **存储：** 50GB+ SSD

**部署步骤：**

1. 通过 SSH 连接到服务器：
   ```bash
   ssh user@your-server-ip
   ```

2. 安装依赖：
   ```bash
   sudo apt update
   sudo apt install -y git clang curl libssl-dev llvm libudev-dev build-essential
   ```

3. 安装 Rust：
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   source ~/.cargo/env
   rustup default stable
   rustup target add wasm32-unknown-unknown
   ```

4. 克隆并构建：
   ```bash
   git clone https://github.com/cshonor/create-chain-substrate-node-template-rust.git
   cd create-chain-substrate-node-template-rust
   cargo build --release
   ```

5. 配置为系统服务（使用 systemd）：
   ```bash
   # 创建服务文件
   sudo nano /etc/systemd/system/substrate-node.service
   ```

   添加以下内容：
   ```ini
   [Unit]
   Description=Substrate Node
   After=network.target

   [Service]
   Type=simple
   User=your-user
   WorkingDirectory=/path/to/your/node
   ExecStart=/path/to/target/release/solochain-template-node --chain dev --name MyNode
   Restart=always
   RestartSec=10

   [Install]
   WantedBy=multi-user.target
   ```

   启用并启动服务：
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable substrate-node
   sudo systemctl start substrate-node
   ```

**环境对比：**

| 环境 | 使用场景 | 优点 | 缺点 |
|------------|----------|------|------|
| **WSL** | 本地开发与测试 | 易于设置，无成本，便于调试 | 不适合 24/7 运行 |
| **云服务器** | 生产环境部署 | 24/7 运行，网络更好，可扩展 | 需要服务器成本，设置较复杂 |
| **Docker** | 一致的构建环境 | 随处可用，隔离环境 | 需要 Docker 知识 |

### 常见问题与故障排除

#### 1. 版本标签不存在错误

**错误信息：**
```
fatal: couldn't find remote ref refs/tags/polkadot-sdk-v1.2.1
```

**原因：** `Cargo.toml` 中指定了不存在的 Polkadot SDK 版本标签。

**解决方案：**
- 已修复：项目现在使用 `master` 分支（最新稳定版本）
- 如果遇到类似问题，检查 `Cargo.toml` 中的 `tag = "xxx"` 是否有效
- 可以移除 `tag` 参数，使用默认的 `master` 分支

#### 2. scale-info 版本不匹配

**错误信息：**
```
error: failed to select a version for the requirement `scale-info = "^2.13.0"`
candidate versions found which didn't match: 2.11.6, 2.11.5, ...
```

**原因：** 指定的 `scale-info` 版本在 crates.io 镜像中不存在。

**解决方案：**
- 已修复：将 `scale-info` 版本从 `2.13.0` 改为 `2.11`（Cargo 会自动选择兼容版本）
- 如果仍有问题，可以尝试：
  ```bash
  # 检查可用版本
  cargo search scale-info
  
  # 或使用官方 crates.io（如果使用镜像）
  # 编辑 ~/.cargo/config.toml，移除或注释掉镜像配置
  ```

#### 3. 重复 lang item 错误

**错误信息：**
```
error[E0152]: duplicate lang item in crate `core` (which `std` depends on): `sized`
```

**原因：** Rust 工具链冲突或构建缓存损坏。

**解决方案：**
```bash
# 1. 清理构建缓存
cargo clean

# 2. 重新安装 wasm32-unknown-unknown 目标
rustup target remove wasm32-unknown-unknown
rustup target add wasm32-unknown-unknown

# 3. 更新 Rust 工具链
rustup update stable

# 4. 重新构建
cargo build --release
```

#### 4. WSL 文件系统性能问题

**问题：** 在 Windows 文件系统（`/mnt/c/...`）上编译非常慢。

**解决方案：**
- **必须**将项目迁移到 WSL Linux 文件系统（`~/`）
- 使用提供的迁移脚本：`bash scripts/wsl-migrate.sh`
- 或手动复制：`cp -r /mnt/c/path/to/project ~/project`

#### 5. 构建时间过长

**说明：** 首次构建需要 10-30 分钟是正常的，因为需要：
- 下载所有依赖（包括整个 Polkadot SDK）
- 编译所有依赖项
- 编译项目代码

**优化建议：**
- 确保在 Linux 文件系统中构建（不是 Windows 文件系统）
- 使用 SSD 存储
- 增加并行编译线程：`cargo build --release -j $(nproc)`
- 后续构建会更快（增量编译）

#### 6. Git 仓库同步问题

**问题：** Windows 和 WSL 中的项目文件不同步。

**解决方案：**
- 在 WSL 中手动复制文件：
  ```bash
  cp "/mnt/c/Users/12392/Desktop/node template/my-node-template/Cargo.toml" ~/my-node-template/Cargo.toml
  ```
- 或使用 Git 同步：
  ```bash
  cd ~/my-node-template
  git pull origin main
  ```

#### 7. 网络连接问题

**问题：** 无法从 GitHub 下载依赖。

**解决方案：**
- 配置 Git 代理（如果需要）
- 使用国内镜像（已配置 tuna 镜像）
- 检查网络连接和防火墙设置

#### 8. duplicate lang item 错误（build-std 冲突）

**错误信息：**
```
error[E0152]: duplicate lang item in crate `core` (which `std` depends on): `sized`
```

**原因：** 这是 `build-std` 特性与预编译标准库冲突导致的已知问题，在使用 Polkadot SDK master 分支时常见。

**解决方案：**

**方案 A：使用 nightly 工具链构建 WASM（推荐）**
```bash
# 安装 nightly 工具链
rustup toolchain install nightly
rustup target add wasm32-unknown-unknown --toolchain nightly

# 使用 nightly 构建 WASM runtime
WASM_BUILD_TOOLCHAIN=nightly cargo build --release
```

**方案 B：跳过 WASM 构建（快速方案）**
```bash
# 跳过 WASM 构建，只构建节点二进制
SKIP_WASM_BUILD=1 cargo build --release --bin solochain-template-node
```
注意：此方法构建的节点没有 WASM runtime，但可以用于开发和测试。

**方案 C：使用稳定版本的 Polkadot SDK**
如果 master 分支问题持续，考虑使用稳定标签版本：
```bash
# 检查可用稳定版本
git ls-remote --tags https://github.com/paritytech/polkadot-sdk.git | grep -E 'polkadot-v1\.' | tail -10

# 然后更新 Cargo.toml 使用稳定版本（例如：tag = "polkadot-v1.20.0"）
```

#### 9. jsonrpsee 版本冲突

**错误信息：**
```
error[E0277]: the trait bound `Methods: From<RpcModule<...>>` is not satisfied
note: there are multiple different versions of crate `jsonrpsee_core` in the dependency graph
```

**原因：** Polkadot SDK master 分支使用 `jsonrpsee 0.24`，但项目配置可能指定了 `0.23`。

**解决方案：**
```bash
# 更新 Cargo.toml 中的 jsonrpsee 版本
# 将 version = "0.23" 改为 version = "0.24"

# 然后重新构建
cargo clean -p solochain-template-node
cargo build --release
```

**已修复：** 项目已更新为使用 `jsonrpsee = "0.24"`。

#### 10. Rust 版本要求冲突

**错误信息：**
```
error: rustc 1.85.0-nightly is not supported by the following packages:
  time@0.3.46 requires rustc 1.88.0
```

**原因：** 某些依赖需要更新的 Rust 版本。

**解决方案：**
- 使用最新的 nightly 工具链：`WASM_BUILD_TOOLCHAIN=nightly cargo build --release`
- 或使用 stable 工具链（如果满足版本要求）
- 或降级依赖版本（不推荐）

### 项目配置说明

**当前配置：**
- **Polkadot SDK 版本：** `master` 分支（最新稳定版本）
- **Rust 版本：** `stable`（由 `rust-toolchain.toml` 指定）
- **scale-info 版本：** `2.11`（自动选择兼容版本）
- **jsonrpsee 版本：** `0.24`（匹配 Polkadot SDK master 分支）
- **构建目标：** `wasm32-unknown-unknown` + `x86_64-unknown-linux-gnu`
- **WASM 构建工具链：** 建议使用 `nightly`（通过 `WASM_BUILD_TOOLCHAIN` 环境变量）

**重要文件：**
- `Cargo.toml` - 项目依赖配置
- `rust-toolchain.toml` - Rust 工具链版本
- `scripts/wsl-*.sh` - WSL 环境脚本

Fetch solochain template code:

```sh
git clone https://github.com/paritytech/polkadot-sdk-solochain-template.git solochain-template

cd solochain-template
```

### Build

🔨 Use the following command to build the node without launching it:

```sh
cargo build --release
```

### Embedded Docs

After you build the project, you can use the following command to explore its
parameters and subcommands:

```sh
./target/release/solochain-template-node -h
```

You can generate and view the [Rust
Docs](https://doc.rust-lang.org/cargo/commands/cargo-doc.html) for this template
with this command:

```sh
cargo +nightly doc --open
```

### Single-Node Development Chain

The following command starts a single-node development chain that doesn't
persist state:

```sh
./target/release/solochain-template-node --dev
```

To purge the development chain's state, run the following command:

```sh
./target/release/solochain-template-node purge-chain --dev
```

To start the development chain with detailed logging, run the following command:

```sh
RUST_BACKTRACE=1 ./target/release/solochain-template-node -ldebug --dev
```

Development chains:

- Maintain state in a `tmp` folder while the node is running.
- Use the **Alice** and **Bob** accounts as default validator authorities.
- Use the **Alice** account as the default `sudo` account.
- Are preconfigured with a genesis state (`/node/src/chain_spec.rs`) that
  includes several pre-funded development accounts.


To persist chain state between runs, specify a base path by running a command
similar to the following:

```sh
// Create a folder to use as the db base path
$ mkdir my-chain-state

// Use of that folder to store the chain state
$ ./target/release/solochain-template-node --dev --base-path ./my-chain-state/

// Check the folder structure created inside the base path after running the chain
$ ls ./my-chain-state
chains
$ ls ./my-chain-state/chains/
dev
$ ls ./my-chain-state/chains/dev
db keystore network
```

### Connect with Polkadot-JS Apps Front-End

After you start the node template locally, you can interact with it using the
hosted version of the [Polkadot/Substrate
Portal](https://polkadot.js.org/apps/#/explorer?rpc=ws://localhost:9944)
front-end by connecting to the local node endpoint. A hosted version is also
available on [IPFS](https://dotapps.io/). You can
also find the source code and instructions for hosting your own instance in the
[`polkadot-js/apps`](https://github.com/polkadot-js/apps) repository.

### Multi-Node Local Testnet

If you want to see the multi-node consensus algorithm in action, see [Simulate a
network](https://docs.substrate.io/tutorials/build-a-blockchain/simulate-network/).

## Template Structure

A Substrate project such as this consists of a number of components that are
spread across a few directories.

### Node

A blockchain node is an application that allows users to participate in a
blockchain network. Substrate-based blockchain nodes expose a number of
capabilities:

- Networking: Substrate nodes use the [`libp2p`](https://libp2p.io/) networking
  stack to allow the nodes in the network to communicate with one another.
- Consensus: Blockchains must have a way to come to
  [consensus](https://docs.substrate.io/fundamentals/consensus/) on the state of
  the network. Substrate makes it possible to supply custom consensus engines
  and also ships with several consensus mechanisms that have been built on top
  of [Web3 Foundation
  research](https://research.web3.foundation/Polkadot/protocols/NPoS).
- RPC Server: A remote procedure call (RPC) server is used to interact with
  Substrate nodes.

There are several files in the `node` directory. Take special note of the
following:

- [`chain_spec.rs`](./node/src/chain_spec.rs): A [chain
  specification](https://docs.substrate.io/build/chain-spec/) is a source code
  file that defines a Substrate chain's initial (genesis) state. Chain
  specifications are useful for development and testing, and critical when
  architecting the launch of a production chain. Take note of the
  `development_config` and `testnet_genesis` functions. These functions are
  used to define the genesis state for the local development chain
  configuration. These functions identify some [well-known
  accounts](https://docs.substrate.io/reference/command-line-tools/subkey/) and
  use them to configure the blockchain's initial state.
- [`service.rs`](./node/src/service.rs): This file defines the node
  implementation. Take note of the libraries that this file imports and the
  names of the functions it invokes. In particular, there are references to
  consensus-related topics, such as the [block finalization and
  forks](https://docs.substrate.io/fundamentals/consensus/#finalization-and-forks)
  and other [consensus
  mechanisms](https://docs.substrate.io/fundamentals/consensus/#default-consensus-models)
  such as Aura for block authoring and GRANDPA for finality.


### Runtime

In Substrate, the terms "runtime" and "state transition function" are analogous.
Both terms refer to the core logic of the blockchain that is responsible for
validating blocks and executing the state changes they define. The Substrate
project in this repository uses
[FRAME](https://docs.substrate.io/learn/runtime-development/#frame) to construct
a blockchain runtime. FRAME allows runtime developers to declare domain-specific
logic in modules called "pallets". At the heart of FRAME is a helpful [macro
language](https://docs.substrate.io/reference/frame-macros/) that makes it easy
to create pallets and flexibly compose them to create blockchains that can
address [a variety of needs](https://substrate.io/ecosystem/projects/).

Review the [FRAME runtime implementation](./runtime/src/lib.rs) included in this
template and note the following:

- This file configures several pallets to include in the runtime. Each pallet
  configuration is defined by a code block that begins with `impl
  $PALLET_NAME::Config for Runtime`.
- The pallets are composed into a single runtime by way of the
  [#[runtime]](https://paritytech.github.io/polkadot-sdk/master/frame_support/attr.runtime.html)
  macro, which is part of the [core FRAME pallet
  library](https://docs.substrate.io/reference/frame-pallets/#system-pallets).

### Pallets

The runtime in this project is constructed using many FRAME pallets that ship
with [the Substrate
repository](https://github.com/paritytech/polkadot-sdk/tree/master/substrate/frame) and a
template pallet that is [defined in the
`pallets`](./pallets/template/src/lib.rs) directory.

A FRAME pallet is comprised of a number of blockchain primitives, including:

- Storage: FRAME defines a rich set of powerful [storage
  abstractions](https://docs.substrate.io/build/runtime-storage/) that makes it
  easy to use Substrate's efficient key-value database to manage the evolving
  state of a blockchain.
- Dispatchables: FRAME pallets define special types of functions that can be
  invoked (dispatched) from outside of the runtime in order to update its state.
- Events: Substrate uses
  [events](https://docs.substrate.io/build/events-and-errors/) to notify users
  of significant state changes.
- Errors: When a dispatchable fails, it returns an error.

Each pallet has its own `Config` trait which serves as a configuration interface
to generically define the types and parameters it depends on.

## Alternatives Installations

Instead of installing dependencies and building this source directly, consider
the following alternatives.

### Nix

Install [nix](https://nixos.org/) and
[nix-direnv](https://github.com/nix-community/nix-direnv) for a fully
plug-and-play experience for setting up the development environment. To get all
the correct dependencies, activate direnv `direnv allow`.

### Docker

Please follow the [Substrate Docker instructions
here](https://github.com/paritytech/polkadot-sdk/blob/master/substrate/docker/README.md) to
build the Docker container with the Substrate Node Template binary.
