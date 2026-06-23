# Word & Night (Game Jam Prototype)

A text-based puzzle game prototype built with Godot 4, heavily inspired by "Baba Is You" and traditional MUDs.

## Overview
This game explores the concept of "Editing Reality in the Day, Surviving Reality in the Night". Players navigate a minimalist, grid-based world where words act as physical obstacles. By interacting with dynamic sentences during the day, players can alter the physical layout of the world when night falls.

## Current Implemented Features

### 1. Dual-Phase System (Day & Night)
- **Day Phase (The Logical Realm)**:
  - The world consists entirely of text.
  - All text entities (e.g., `the`, `door`, `is`, `locked`, `wall`) are solid obstacles.
  - Physical doors are impassable.
  - The player can safely walk around and edit interactive text.
- **Night Phase (The Physical Realm)**:
  - Text entities lose their physical form.
  - Physical walls and doors are rendered as solid blocks.
  - The state of the physical doors depends entirely on the logical sentences formed during the Day phase.

### 2. "You" Player Controller
- The player is visually represented as the golden word `you`.
- Orthogonal grid-based movement (`Arrow Keys` or `WASD`).
- Strict 64x64 pixel grid collision system.

### 3. Word-Based Interaction
- Sentences are fully decoupled into individual 64x64 grid cells.
- **Editing**: Press `E` while standing adjacent to an interactive word (e.g., `locked`) to cycle its value (e.g., `open`).
- The interaction is logically decoupled from the physical object it controls (the sentence can be in one room, while the door it controls is in another).

### 4. Dynamic UI & Win Condition
- A top instructional HUD dynamically adapts to the current Day/Night phase.
- A hidden "Win Block" exists deep within the final room, visible only at night.
- Reaching and touching the Win Block triggers the `YOU WIN!` sequence.

## Controls
- **Move**: `Arrow Keys`
- **Interact / Edit Word**: `E` (Must be directly adjacent to the word)
- **Toggle Day/Night Phase**: `Space` or `Enter`

---

# Word & Night (Game Jam 游戏原型)

这是一个使用 Godot 4 构建的纯文字解谜游戏原型，深受《Baba Is You》和传统 MUD（多用户地牢）游戏的启发。

## 游戏概述
本作探讨了“在白天编辑现实，在黑夜生存在现实”的核心概念。玩家将在一片极简的网格世界中穿梭，在这里，文字本身就是物理障碍。通过在“白天”与地图上的句子互动并篡改它们，玩家可以在“黑夜”降临时改变这个世界的物理形态。

## 目前已实现的功能

### 1. 昼夜双相位系统
- **白天相位（逻辑位面）**：
  - 世界完全由打散的文字组成。
  - 所有的文字实体（例如：`the`、`door`、`is`、`locked`、`wall`）都是坚不可摧的物理障碍。
  - 真正的物理门在白天永远处于锁死状态。
  - 玩家可以安全地四处探索，并编辑可交互的文字。
- **黑夜相位（物理位面）**：
  - 文字失去物理实体（不再阻挡玩家）。
  - 物理墙壁和门会变成实体的深色方块。
  - 物理门的开/关状态，完全取决于白天所设置的逻辑法则（句子）。

### 2. “You” 玩家控制器
- 玩家的视觉形象是一个金色的 `you` 单词。
- 基于正交网格的移动系统（使用 `方向键` 或 `WASD`）。
- 严谨的 64x64 像素物理网格碰撞判定。

### 3. 基于单字的交互系统
- 所有的句子都被打散，每个单词独立占据一个 64x64 的格子。
- **编辑现实**：玩家只要“贴脸”站在可交互单词（如 `locked`）的上下左右格子，按下 `E` 键，就能将其修改（例如改成 `open`）。
- 实现了“异地控制”（逻辑与物理彻底解耦）：操控大门的逻辑句子可以在地图这头的左侧房间，而受它控制的那扇门可能远在地图另一头的右侧。

### 4. 动态 UI 与胜利判定
- 顶部的操作提示 HUD 会根据昼夜相位的切换自动变化。
- 终点房间深处藏着一个“胜利方块”（Win Block），它仅在黑夜中显形。
- 触碰该方块会立即触发 `YOU WIN!` 胜利事件。

## 操作按键
- **移动**：`方向键` 或 `WASD`
- **交互 / 修改单词**：`E`（必须紧挨着目标单词）
- **切换 昼/夜 相位**：`空格键` 或 `回车键`
