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

## Reference Files

- [AURORA_DESIGN_SYSTEM.md](AURORA_DESIGN_SYSTEM.md) — Complete design token reference (colors, sizes, spacing, typography, icons, opacity).
- [COMPONENT_LIBRARY.md](COMPONENT_LIBRARY.md) — Component catalog: buttons, DataGrid, toggle switches, cards, toolbar patterns, dialogs.
- [WPF_XAML_PATTERNS.md](WPF_XAML_PATTERNS.md) — WPF/XAML coding patterns: style resolution, resource dictionaries, data binding, MVVM with source generators.
- [GUI_STANDARDS.md](GUI_STANDARDS.md) — Standardization rules, layout conventions, conditional compilation, and project settings.

## Non-Negotiables

- Never hardcode Width, Height, Margin, Padding, FontSize, or CornerRadius — always use Aurora tokens.
- Never introduce a new color without adding it to `AuroraColors.xaml`.
- Never set `AutoGenerateColumns="True"` on DataGrid — always define columns explicitly.
- Do not mix implicit and explicit styles on the same element — explicit setters override implicit `BasedOn` styles.
- Do not use `x:Null` as a converter — create a proper `IValueConverter`.
- Do not add unrelated refactoring; focus on what serves the current UI task.
