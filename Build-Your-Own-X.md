# Build Your Own X — 通过造轮子掌握技术

> *"Master programming by recreating your favorite technologies from scratch."*

🔗 **GitHub**: <https://github.com/codecrafters-io/build-your-own-x>
⭐ **Star**: 380k+
📜 **License**: CC BY-SA

---

## 📖 项目简介

**Build Your Own X** 是 GitHub 上最受欢迎的程序员学习资源之一，最初由 [Danistefanovic](https://github.com/danistefanovic) 创建，现在由 [Codecrafters](https://codecrafters.io) 团队维护。

它是一份**精选教程合集**，收录了大量「**从零实现 XX**」的优质教程，覆盖操作系统、数据库、网络协议、Web 框架、编译器、游戏、神经网络等几乎所有计算机核心领域。

**核心理念**：

> 想要真正理解一项技术，最快的方式不是读它的源码，而是**亲手从零把它写出来**。

---

## 🎯 为什么值得花时间去做

### 1. 真正吃透底层原理

读 Redis 文档只能知道「怎么用」，但当你从零写完一个 mini Redis，你会自然明白：

- RESP 协议长什么样、怎么序列化
- 事件循环（epoll / kqueue）怎么处理高并发
- 持久化（RDB / AOF）如何实现
- 内存淘汰策略（LRU / LFU）怎么落地

这些知识光靠看文章是装不进脑子里的。

### 2. 把零散知识点串成网

一个 mini 数据库项目会让你**同时**掌握：

- 文件 I/O 与内存映射（mmap）
- B 树 / LSM 树数据结构
- SQL 解析器与执行器
- 网络通信与协议设计
- 锁与并发控制

这种跨领域的整合能力，是「调包侠」很难获得的。

### 3. 简历上的硬通货

> 「读过 Redis 源码」 vs 「自己实现过 Redis」

面试官一眼就能看出区别。这种项目经历放在简历里，是非常有说服力的。

---

## 📂 涵盖领域（部分）

| 类别 | 代表项目 |
|------|---------|
| 🖼 3D 渲染 | Ray tracer、光线追踪器 |
| 💻 操作系统 | 小型 OS、Unix Shell |
| 🔤 编程语言 | 解释器、编译器、正则引擎 |
| 🗄 数据库 | 关系型数据库、KV 存储、Redis |
| 🌐 Web | Web 服务器、浏览器、Docker |
| 📡 网络 | BitTorrent、聊天软件、负载均衡器 |
| 🛠 工具 | Git、Docker、Vim |
| 🎮 游戏 | 小游戏、Game Boy 模拟器 |
| 🧠 AI | 神经网络、机器学习库 |
| ⚙ 其他 | 物理引擎、加密货币、QR 码生成器 |

完整列表见仓库 README。

---

## 🚀 如何使用这份清单

### 推荐学习节奏

1. **挑选一个最感兴趣的领域**：不要贪多，**先选一个**你最想搞懂的技术
2. **跟着教程走一遍**：不要一上来就自己写，先理解作者的设计思路
3. **脱离教程重写**：关掉参考，用自己的代码重新实现一遍，卡住的地方就是你没真正理解的地方
4. **加新功能**：比如写完 mini Redis 后，自己加一个 cluster 模块

### 时间分配建议

- ⏱ **每天 2-3 小时**，一个项目 **2-4 周**
- 📝 **写博客 / 笔记**：把过程记录下来，既能复习也能分享
- 🧪 **写测试**：尤其是网络、数据库类项目，必须有测试兜底
- 🗣 **找人 Review**：去 GitHub 上传项目、找社区反馈

---

## 💡 推荐入门项目（由易到难）

| 难度 | 项目 | 预估时长 |
|------|------|---------|
| 🟢 入门 | Build your own Regex | 1-2 天 |
| 🟢 入门 | Build your own Shell | 3-5 天 |
| 🟡 进阶 | Build your own Git | 1-2 周 |
| 🟡 进阶 | Build your own Redis | 2-3 周 |
| 🔴 高级 | Build your own Docker | 3-4 周 |
| 🔴 高级 | Build your own Database | 4-6 周 |
| ⚫ 大神 | Build your own OS | 2-3 月 |

> 💬 **建议**：第一次从 🟢 入门项目开始，培养「从零搭建」的信心和节奏感。

---

## 🔗 相关资源

- **官方仓库**：<https://github.com/codecrafters-io/build-your-own-x>
- **Codecrafters 平台**（付费，结构化分阶段挑战）：<https://codecrafters.io>
- **配套项目**：仓库作者团队还提供 CodeCrafters 平台，包含 Redis、Git、Docker、SQLite 等项目的分阶段实战挑战

---

## ✍️ 写在最后

> 纸上得来终觉浅，绝知此事要躬行。

这个仓库最大的价值不在于「**读完**」，而在于「**动手做**」。

与其收藏吃灰，不如**今天就挑一个小项目开始**。哪怕每天只推进一点点，一个月后你都会感谢现在动手的自己。

**Happy hacking! 🚀**