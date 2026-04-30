---
name: wpf-aurora-ui
description: Build WPF desktop UIs using the Aurora design system — a production-tested token-based framework for .NET 10 WPF applications. Use when developing new WPF windows, dialogs, toolbars, DataGrid views, or maintaining consistent appearance across multi-project WPF solutions.
---

# WPF Aurora UI Design System

## When To Use

Use this skill for any WPF desktop UI work that should follow a consistent, token-based design language with shared styles, standardized spacing, and MVVM architecture.

Best fit:

- Main application windows and tool windows.
- Toolbars with icon+text buttons and toggle switches.
- DataGrid-heavy monitoring and configuration panels.
- Dialog windows (About, settings, utilities, project selection).
- Card-based dashboards and status panels.
- Any new WPF project in a multi-project solution.

Avoid this skill for web frontends, mobile apps, console tools, or non-WPF desktop frameworks (Tauri, Electron, etc.).

## Core Direction

Build professional Windows desktop UIs with Aurora:

- **Token-based design**: All colors, sizes, spacing, and corner radii come from centralized resource dictionaries — no hardcoded values.
- **AuroraDataGrid** as the standard table style: light background, subtle borders, full-row selection with blue highlight.
- **Toolbar pattern**: Icon+text buttons with hover/pressed states, toggle switches, and field labels for combo boxes.
- **Card surfaces**: `ui:Card` or bordered `Border` with `CornerRadius="8"`, raised background, and subtle border.
- **MVVM with CommunityToolkit.Mvvm**: ViewModel-first, `[ObservableProperty]` / `[RelayCommand]` source generators.
- **Green toggle switches**: iOS-style pill toggles using `GreenToggleSwitch` style for ON/OFF states (green = ON, gray = OFF).

## Workflow

1. Identify the surface type: toolbar, DataGrid, card, dialog, or settings panel.
2. Load Aurora styles via App.xaml `MergedDictionaries` (see [GUI_STANDARDS.md](GUI_STANDARDS.md)).
3. Reuse existing Aurora tokens for all dimensions and colors — never hardcode.
4. Follow MVVM pattern: View (`.xaml`) → ViewModel (`*ViewModel.cs`) → Model.
5. Use CommunityToolkit.Mvvm source generators (`[ObservableProperty]`, `[RelayCommand]`).
6. Reference icons from `AuroraIcons.xaml` (shared geometry resources) or `ui:SymbolIcon`.

## Public Repository

Aurora 公共库以 git submodule 方式集成到主项目中：

- **GitHub**：`https://github.com/legendsonldh/Aurora.git`
- **SSH**：`git@github.com:legendsonldh/Aurora.git`
- **引入方式**：`git submodule add git@github.com:legendsonldh/Aurora.git Aurora`
- **NuGet 包名**：`CADE.Aurora`（内部引用，尚未发布到 NuGet.org）
- **文档**：仓库内包含完整的 AuroraColors.xaml、AuroraSizes.xaml、Button.xaml、AuroraDataGrid.xaml 等资源字典

项目通过 `.csproj` 的 `ProjectReference` 直接引用：

```xml
<ProjectReference Include="..\Aurora\CADE.Aurora.csproj" />
```

## Reference Files

- [AURORA_DESIGN_SYSTEM.md](AURORA_DESIGN_SYSTEM.md) — Complete design token reference (colors, sizes, spacing, typography, icons, opacity).
- [COMPONENT_LIBRARY.md](COMPONENT_LIBRARY.md) — Component catalog: buttons, DataGrid, toggle switches, cards, toolbar patterns, dialogs.
- [WPF_XAML_PATTERNS.md](WPF_XAML_PATTERNS.md) — WPF/XAML coding patterns: style resolution, resource dictionaries, data binding, MVVM with source generators.
- [GUI_STANDARDS.md](GUI_STANDARDS.md) — Standardization rules, layout conventions, conditional compilation, and project settings.

## Design Philosophy

Aurora 的设计理念来源于以下几个方向：

- **Microsoft Fluent Design**：主色调 `#0078D4`（标准 Fluent Blue），卡片式层级结构（SurfaceRaisedBackground 浮于 SecondaryBackground 之上），微妙边框与阴影，整体干净、通透的视觉语言。
- **WPF-UI 库 (lepo.co)**：提供 `ui:Card`、`ui:SymbolIcon`、`ui:ThemesDictionary` 等现代 WinUI 风格控件，是 Aurora 的基础控件骨架。
- **企业桌面应用的实用性**：Aurora 服务于工业级桌面工具——高密度 DataGrid 监控面板、实时数据可视化、键盘可访问的工具栏。形式追随功能，美观服务于效率。
- **从重复中提炼一致性**：Aurora 并非从零设计的系统，而是从 ControlPanel、DataBrowser、Telescope、VGPM、ConfigEditor 五个项目中提取公共样式后抽象而来。每个 token 都经过真实产品验证，不是空中楼阁。
- **.NET 10 + Windows Native**：直接面向 `net10.0-windows`，利用 WPF 原生渲染引擎，通过 P/Invoke 与原生 C++ 模块（如 LicenseManager）互操作。不做跨平台抽象层，专注于 Windows 桌面体验的深度优化。
- **干净专业的 Windows 桌面风格**：遵循经典 Windows 桌面 UI 惯例，同时通过 Fluent 启发的设计令牌进行现代化——不过度设计，不追求消费级动效，保持专业工具应有的稳重与清晰。

核心原则：**一套 token，五个项目，一个来源**。

## Non-Negotiables

- Never hardcode Width, Height, Margin, Padding, FontSize, or CornerRadius — always use Aurora tokens.
- Never introduce a new color without adding it to `AuroraColors.xaml`.
- Never set `AutoGenerateColumns="True"` on DataGrid — always define columns explicitly.
- Do not mix implicit and explicit styles on the same element — explicit setters override implicit `BasedOn` styles.
- Do not use `x:Null` as a converter — create a proper `IValueConverter`.
- Do not add unrelated refactoring; focus on what serves the current UI task.
