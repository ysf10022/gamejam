# Word & Night (Game Jam Prototype)

A text-based puzzle game prototype built with Godot 4, heavily inspired by "Baba Is You" and traditional MUDs.

## Overview
This game explores the concept of "Editing Reality in the Day, Surviving Reality in the Night". Players navigate a minimalist, grid-based world where words act as physical obstacles. By interacting with dynamic sentences during the day, players can alter the physical layout of the world when night falls.

## Current Implemented Features

### 1. Dual-Phase System (Day & Night)
- **Day Phase (The Logical Realm)**: The world consists entirely of text. All text entities are solid obstacles. Physical doors are impassable. The player can edit interactive text.
- **Night Phase (The Physical Realm)**: Text entities lose their physical form. Physical walls and doors are rendered as solid blocks. The state of the physical doors depends entirely on the logical sentences formed during the Day phase.

### 2. "You" Player Controller
- The player is visually represented as the golden word `you`.
- Orthogonal grid-based movement (`Arrow Keys` or `WASD`).
- Strict 64x64 pixel grid collision system.

### 3. Word-Based Interaction & Decoupling
- Sentences are fully decoupled into individual 64x64 grid cells.
- **Editing**: Press `E` while standing adjacent to an interactive word (e.g., `locked`) to cycle its value.
- **Tele-Control**: The interaction is logically decoupled from the physical object it controls (the sentence can be in one room, while the door it controls is in another).

### 4. Dynamic UI & Win Condition
- A top instructional HUD dynamically adapts to the current Day/Night phase.
- Reaching and touching the hidden "Win Block" at night triggers the `YOU WIN!` sequence.

### 5. WYSIWYG Node-Based Visual Level Editor
- Completely decoupled data architecture. Zero hardcoded coordinates in scripts.
- **Prefab System**: Use ready-made components (`StaticWord`, `ClauseWord`, `PhysicalDoor`, `WinBlock`, `PlayerSpawn`).
- **TileMap Integration**: Paint physical walls using the Godot 2D TileMap editor.

## Controls
- **Move**: `Arrow Keys` or `WASD`
- **Interact / Edit Word**: `E` (Must be directly adjacent to the word)
- **Toggle Day/Night Phase**: `Space` or `Enter`

---

# Word & Night (Game Jam 游戏原型)

这是一个使用 Godot 4 构建的纯文字解谜游戏原型，深受《Baba Is You》和传统 MUD（多用户地牢）游戏的启发。

## 游戏概述
本作探讨了“在白天编辑现实，在黑夜生存在现实”的核心概念。玩家将在一片极简的网格世界中穿梭，在这里，文字本身就是物理障碍。通过在“白天”与地图上的句子互动并篡改它们，玩家可以在“黑夜”降临时改变这个世界的物理形态。

## 目前已实现的功能

### 1. 昼夜双相位系统
- **白天相位（逻辑位面）**：世界完全由文字组成，所有文字都是物理障碍。物理门永久锁死。
- **黑夜相位（物理位面）**：文字失去物理实体。物理墙壁和门会变成实体的深色方块。物理门的开/关状态取决于白天所设置的逻辑法则。

### 2. “You” 玩家控制器
- 玩家的视觉形象是一个金色的 `you` 单词，支持正交网格移动。

### 3. 基于单字的交互系统 & 异地控制
- **编辑现实**：玩家“贴脸”站在可交互单词（如 `locked`）旁按 `E` 键即可修改其状态。
- **异地控制**：逻辑与物理彻底解耦，操控大门的逻辑句子和受控实体门可以被布置在地图的任意角落。

### 4. 动态 UI 与胜利判定
- 顶部的操作提示 HUD 根据昼夜自动变化。触碰黑夜中的“胜利方块”即可通关。

### 5. 所见即所得 (WYSIWYG) 的节点化可视化编辑器
- **彻底告别硬编码**：底层数据中心完全动态化，代码中不再写死任何坐标。
- **多地形物理画笔**：原生集成了上帝视角的 TileMap 涂鸦面板，支持绘制 墙壁、火、水 和 草地，每种材质都有独立的物理规则与昼夜视觉表现。
- **“量子纠缠”自动对齐**：所有关卡积木（文字、门等）不管你在编辑器里摆得多歪，运行瞬间都会自动吸附并完美对齐到 64x64 的物理网格中心，彻底消灭视觉与逻辑脱节的 Bug！
- **极简关卡搭建**：支持直接在 Godot 视图中拖拽预制体积木（门、单词、机关），并在编辑器内实时渲染预览！

---

## 🛠️ 关卡编辑器使用指南 (Step-by-Step Level Editor Guide)

为了让团队中的关卡设计师和美术同学能无代码障碍地协同工作，我们构建了这一套基于预制体（Prefabs）和 TileSet 的关卡管线。

### 准备工作：创建你的新关卡
1. 在文件系统中找到 `scenes/Level_01.tscn`，右键点击**复制 (Duplicate)**，命名为 `Level_02.tscn`。
2. 双击打开 `Level_02.tscn`，**不要**直接在 `main.tscn` 中拼地图。

### 第一步：使用多材质 TileMap 刷出地形
1. 在场景树（Scene Tree）中点击选中 `WallsMap` 节点。
2. 展开编辑器底部的 **TileMap 面板**。
3. 你会看到 4 种颜色的画笔，它们分别代表：
   - ⬜ **白色 (ID 0) = Wall (墙)**：日夜均阻挡玩家，白天显示为 `wall`。
   - 🟥 **红色 (ID 1) = Fire (火)**：日夜均阻挡玩家，白天显示为 `fire`。
   - 🟦 **蓝色 (ID 2) = Water (水)**：日夜均阻挡玩家，白天显示为 `water`。
   - 🟩 **绿色 (ID 3) = Grass (草)**：**允许玩家通行**，白天显示为 `grass`。
4. 选好画笔，在上方的 2D 视图中尽情涂抹你的地形吧！

### 第二步：拖拽预制体 (Prefabs) 搭建解谜机关
打开 `prefabs/` 文件夹，将对应的组件拖拽到 2D 场景中。因为底层的“自动吸附网格”技术，你现在**可以随意拖拽**，不需要强迫症般地对齐网格，游戏运行时它们会自动居中！

以下是五大核心积木的使用说明：

* **1. PlayerSpawn.tscn (玩家出生点)**
  * **用法**：拖入场景。玩家每次进入该关卡时，都会从这个金色的 `Spawn` 所在格子出生。

* **2. StaticWord.tscn (静态单词)**
  * **用法**：拖入场景。选中它后，在右侧 Inspector 的 `Word` 属性中填入你要的单词（比如 `the`, `I love`）。单词会立刻显示。这类单词在白天是纯粹的物理障碍。

* **3. ClauseWord.tscn (逻辑法则交互词)**
  * **用法**：拖入场景。在右侧 Inspector 中配置：
    * `Clause Id`: 这句话的全局唯一标识（例如：`door2_status`）。
    * `Options`: 玩家按 E 键可以循环切换的词汇列表（例如 `["locked", "open"]`）。
  * **提示**：它会显示为金色，代表玩家可以与之交互。

* **4. PhysicalDoor.tscn (物理门)**
  * **用法**：拖入场景，作为挡路的实体门。
  * **逻辑绑定**：在 Inspector 中将其 `Clause Id` 填为与上述逻辑词一致。
  * **美术替换**：直接将贴图拖入它的 `Sprite` 属性槽即可一键换皮。

* **5. WinBlock.tscn (胜利方块)**
  * **用法**：拖入场景。玩家在黑夜碰到它即可过关。

### 第三步：装载并运行关卡
1. 关卡拼好后，打开核心场景 **`scenes/main.tscn`**。
2. 选中最顶部的 `Main` 节点。
3. 在右侧 Inspector 的 **`Level Scene`** 属性槽中，把你刚才做好的 `Level_02.tscn` 拖进去。
4. 点击右上角的“运行游戏” (Play Project)，开始体验你的杰作吧！
