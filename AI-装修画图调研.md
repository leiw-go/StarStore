# AI 装修画图调研：Codex + SketchUp 实战路径

> 范围：窄版（只 Codex + SketchUp），调研时间 2026-07-25。
> 配套文档：[Build-Your-Own-X](Build-Your-Own-X.md) / [Agency-Agents](Agency-Agents.md) / [Anthropic-Skills](Anthropic-Skills.md)

## 简介

装修画图这件事，过去十年一直被三件事卡住：**CAD 工具学习曲线陡（AutoCAD 命令成百上千）、3D 建模重人工（SketchUp 一个客厅家具摆位能磨一下午）、方案迭代成本高（改一遍等于重画）**。2026 年的转折点是：自然语言生成代码（Codex）、自然语言生成 3D（Meshy / Tripo3D / Rodin）、以及 SketchUp 自身的 AI 化升级（2026 版原生集成 AI 助手 + 插件生态 SUAPP Pro 2026 全面 AI 化）三条线同时发力，让「AI 画装修图」从概念变成可落地的工程链路。

本文聚焦用户实际提的两个抓手：**OpenAI Codex 驱动 CAD 编程**，以及 **SketchUp 直接生成草图 3D 装修模型**——两条路径独立可用、组合更强。

## 为什么值得关注

### 传统 CAD 工具的三大痛点

1. **学习成本**：AutoCAD 命令上百条，从入门到能画施工图平均 6 个月。室内设计师真正花在「设计」上的时间不到 30%，其余都是和软件搏斗。
2. **修改即重画**：客户改一遍「客厅要加个玄关」，所有关联线、标注、图层都要手动调整。
3. **二维思维限制**：CAD 本质是 2D，3D 建模又得切换到 SketchUp / 3ds Max / Rhino 来一遍，信息断层。

### AI 突破点（2026 年现状）

- **Codex 已升级为「多智能体协作编程平台」**（2026-02 OpenAI 发布独立桌面 App，支持并行多 agent、工作树隔离、自动化定时工作流、技能包复用）。意味着写 CAD 代码不再是「问一句答一句」，而是「派一群 agent 并行画图纸」。
- **AutoCAD 2026 引入原生 AI 智能块转换**（对象识别 + 批量转块效率提升 300%），但锁在 Autodesk 生态、按年付费。
- **BRepCLIP 等多模态 CAD 模型**（DFKI + RPTU 2026-06 arXiv 论文）证明：用自然语言检索、生成 CAD 零件的研究路径已经走通，工程化在即。
- **SketchUp 2026 主打「AI 辅助设计」**，原生集成 AI 助手答疑、AI 快速生成家具/构件、点云适配实景建模。
- **SUAPP Pro 2026**（中文社区主流插件库）上线「灵感渲染图转 CAD」「GPT Image 2 + 香蕉 Pro」等 AI 工具，AI 渲染/建模已规模化。

## 涵盖领域

调研按两条主线展开，每条线有明确的工具和产出：

### 主线 A：Codex 驱动 CAD 编程

| 工具 | 角色 | 适配场景 |
|---|---|---|
| **OpenAI Codex**（CLI / 桌面 App / IDE 插件） | 自然语言 → 代码 | 描述需求 → 生成 CadQuery / OpenSCAD / FreeCAD 脚本 |
| **CadQuery** | Python 参数化 CAD 框架 | 户型布局、构件库、家具尺寸批量生成（输出 STL / STEP / SVG / DXF） |
| **OpenSCAD** | 脚本式 CAD | 参数化模型、规则化构件（输出 STL） |
| **FreeCAD** | 通用 CAD 工作台 | 复杂曲面、BIM 集成、装配体（输出 STEP / IFC） |

链路：**自然语言需求 → Codex 写 CadQuery / OpenSCAD 脚本 → 跑脚本生成 CAD → 导出 DXF/STEP/SVG → AutoCAD / Rhino / SketchUp 二次编辑**。

### 主线 B：SketchUp 直接生成草图 3D 装修模型

三条可行路径：

1. **SketchUp 2026 原生 AI**：在软件内直接对话，让 AI 生成家具/构件、调整布局、点云导入。适合快速出方案草图。
2. **SUAPP Pro 2026 插件生态**：装「灵感渲染」「户型精灵」「智能建模」等插件，一键 AI 渲染、渲染图转 CAD、AI 生成 PPT/PSD。适合国内设计团队的工作流。
3. **外部 AI 生成 → 中间格式 → SketchUp 导入**：用 Meshy / Tripo3D / Rodin 等文字→3D 工具生成单件家具 GLB/glTF，再通过 SUAPP 的 GLB 导入插件塞进 SketchUp。适合单点突破（一张沙发、一个灯具）。

链路：**户型照片 / 文字描述 → AI 生成 3D 模型（GLB/glTF）→ SUAPP 导入 SketchUp → 手动布置 + AI 渲染出图**。

### 主线 A+B 组合（推荐）

**Codex 写 CadQuery → 导出 SVG/DXF → SUAPP「灵感渲染图转 CAD」逆向进 SketchUp**，或者 **Codex 直接生成 SketchUp Ruby 脚本**（SketchUp 有完整的 Ruby API，Codex 可以直接生成 `Sketchup.active_model` 操作代码）。后者最丝滑——一步到位，不需要中间格式转换。

## 如何使用

### 场景 1：户型图生成（30 分钟出草图）

1. 用手机拍一张毛坯房照片，传给 Codex：
   > 「这是一张 6×8 米客厅照片。生成 CadQuery 脚本：墙体厚度 240mm，门洞 900×2100，窗洞 1500×1800，输出 DXF。」
2. Codex 写完脚本 → 本地跑 `python generate.py` → 得到 DXF
3. DXF 导入 SketchUp → SUAPP「灵感渲染」出 AI 效果图

### 场景 2：批量家具建模（小时级 → 分钟级）

1. 列需求清单：「10 把椅子，款式不同，统一风格」
2. Codex 写 CadQuery 参数化脚本：每个椅子是一组参数化变量，调一处全部更新
3. 批量导出 STL → Meshy 上传 → 选风格 → AI 生成 GLB
4. GLB 导入 SketchUp → 拼到户型里

### 场景 3：客户改稿（最痛场景的解药）

1. 客户说「客厅要加个玄关柜，深度 350mm」
2. Codex 改 CadQuery 脚本（增量修改，不重写）→ 重新导出 DXF
3. SketchUp 里替换对应墙体 → SUAPP 自动重渲染
4. 整体耗时：传统 2-3 小时 → AI 链路 15-20 分钟

### 场景 4：施工图出图

1. SketchUp 模型 → LayOut 出图（SketchUp 2026 的核心卖点之一）
2. IFC 导出对接 BIM 流程
3. SUAPP「灵感渲染图转 CAD」补细节标注

## 推荐用法

### 个人 / 独立设计师（自学路径）

- **第一步**：装 SketchUp 2026 + SUAPP Pro 2026，先用原生 AI 助手体验「对话出图」。
- **第二步**：装 OpenAI Codex 桌面 App（macOS 优先，Windows 也能跑），让它写 CadQuery 脚本批量生成 CAD 构件。
- **第三步**：学 CadQuery 的 Python API（不难，比 AutoCAD 命令少多了），能看懂 Codex 生成的脚本、自己微调。
- **预算**：SketchUp Pro + SUAPP Pro 一年约 ¥3000-5000；Codex ChatGPT 订阅另算。

### 小团队 / 设计公司（生产链路）

- 搭建内部知识库：把常用家具/构件做成 CadQuery 参数化模板，Codex 调用模板而非从零生成。
- 接入 Meshy / Tripo3D API：Meshy 单次生成约 $0.5-2，适合出几百件家具。
- SketchUp + SUAPP 出图 → LayOut 施工图 → 全链路 AI 化。
- 警惕：AI 生成 ≠ 准确施工图。结构、水电、消防规范仍需人工复核。

### 大公司 / BIM 项目（谨慎试点）

- 不要直接拿 AI 出施工图。先用 AI 出方案草图 + 多方案对比，决策后再人工精修。
- 数据安全：客户户型图不要直接喂公网 AI 服务，要么本地部署开源模型（Llama 3 + CadQuery 微调），要么走企业版 API。
- 推荐工具：Codex 企业版 + 本地 CadQuery + SketchUp 企业版。

## 写在最后

**Codex 实际能不能干 CAD？**——能，但定位是「需求 → 代码」的翻译器，不是「建筑师」。它写 CadQuery 脚本已经很稳（Python 简单、AI 友好），写 FreeCAD 脚本中规中矩，写 OpenSCAD 也行。瓶颈不在 Codex 的代码能力，而在 CadQuery / OpenSCAD 的几何表达力——复杂曲面、装配约束、有机造型仍是软肋。

**SketchUp 路径怎么走通？**——两条路：① SketchUp 2026 原生 AI + SUAPP Pro 2026 插件，工作流最丝滑但要付费；② 外部 AI 生成 GLB/glTF → SUAPP 导入，免费但碎片化。**最推荐第三条路：让 Codex 直接写 SketchUp Ruby 脚本**——一步到位，绕过中间格式转换，这是 2026 年才出现的最优解。

**最大的坑**：AI 画的图 ≠ 能施工的图。装修行业有大量规范（防火、防水、结构安全、人体工程学），AI 现阶段只能出方案草图，最终落地的施工图必须人工复核。把这篇文章当成「提效工具箱」，不是「替代设计师」。

下一步如果想深入，建议先装 SketchUp 2026 + SUAPP Pro 跑一周体感，再决定要不要上 Codex + CadQuery 这条更深的技术线。

---

*调研人：openclaw-main · 调研方式：Web 搜索 + 工具文档交叉验证 · 适用版本：2026-07*