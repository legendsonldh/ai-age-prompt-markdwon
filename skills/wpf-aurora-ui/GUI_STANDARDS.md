# GUI Standards

## Standardization Rules

### Dimension Rule

**Never hardcode** Width, Height, Margin, Padding, FontSize, or CornerRadius. Always reference Aurora tokens:

```xml
<!-- ❌ Bad -->
<Button Width="100" Height="36" Content="OK"/>

<!-- ✅ Good -->
<Button Style="{StaticResource AuroraButtonNormal}" Content="OK"/>

<!-- Or use resource references: -->
<Button Width="{StaticResource AuroraButtonWidthNormal}"
        Height="{StaticResource AuroraButtonHeightNormal}"
        Content="OK"/>
```

### Color Rule

**Never hardcode** colors. Define new colors in `AuroraColors.xaml` and reference by key:

```xml
<!-- ❌ Bad -->
<TextBlock Foreground="#FF1A1A1A" Text="Hello"/>

<!-- ✅ Good -->
<TextBlock Foreground="{StaticResource TextPrimary}" Text="Hello"/>
```

### Style Priority

When using implicit styles (e.g., AuroraDataGrid targets all DataGrid elements), do NOT set attribute-level overrides that conflict:

```xml
<!-- ❌ Bad — Background="Transparent" overrides implicit DataGrid style -->
<DataGrid Background="Transparent" BorderThickness="0"
          ItemsSource="{Binding Items}"/>

<!-- ✅ Good — let implicit style apply -->
<DataGrid ItemsSource="{Binding Items}"/>
```

### DataGrid Rule

Always set `AutoGenerateColumns="False"` and define columns explicitly. The AuroraDataGrid implicit style sets `AutoGenerateColumns="True"` by default.

## Layout Conventions

### Window Structure

```
Window Background="{StaticResource SecondaryBackground}"
└── Grid
    ├── Header (TextBlock, ToolBar)
    ├── Status Bar (Border, conditionally visible)
    ├── Content (TabControl, Grid, etc.)
    └── Footer (optional, Button row)
```

### Toolbar Pattern

```
Grid (toolbar row)
├── Button (ToolBarButton, icon via Tag)
├── TextBlock (ToolBarFieldLabel)
├── ComboBox
├── TextBlock (ToolBarFieldLabel)
├── ComboBox
├── Button (ToolBarButton)
└── Button (AboutButton, right-aligned via DockPanel)
```

### Card Layout

```
Border (CornerRadius="8", SurfaceRaisedBackground)
└── Grid
    ├── Row 0: Header (title + toggle/action)
    └── Row 1: Content (DataGrid, StackPanel, etc.)
```

## Monitoring/Status Pattern

For status monitoring cards (e.g., VGPM CPM pages):

```
Border (MonitorCard)
└── Grid
    ├── Row 0 (Auto): Card Header
    │   ├── Ellipse (StatusIndicatorDot)
    │   ├── TextBlock (Item name)
    │   └── ToggleButton (GreenToggleSwitch)
    └── Row 1 (*): Content area
        ├── Empty State (StackPanel, centered)
        └── DataGrid (AuroraDataGrid)
```

## Project Settings

### .csproj Configuration

```xml
<PropertyGroup>
    <OutputType>WinExe</OutputType>
    <TargetFramework>net10.0-windows</TargetFramework>
    <Platforms>x64</Platforms>
    <UseWPF>true</UseWPF>
    <PlatformTarget>x64</PlatformTarget>
    <GenerateAssemblyInfo>false</GenerateAssemblyInfo>
    <AppendTargetFrameworkToOutputPath>false</AppendTargetFrameworkToOutputPath>
    <LangVersion>latest</LangVersion>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
</PropertyGroup>
```

### Output Path Convention

Tools output to `ControlPanel\bin\x64\{Debug|Release}\Tools\{ToolName}\`:

```xml
<PropertyGroup Condition="'$(Configuration)|$(Platform)' == 'Debug|x64'">
    <OutputPath>..\ControlPanel\bin\x64\Debug\Tools\ToolName\</OutputPath>
</PropertyGroup>
```

### Post-Build Cleanup

Remove unnecessary subdirectories except locale and runtimes:

```xml
<Target Name="PostBuildCleanup" AfterTargets="Build" Condition="'$(OS)' == 'Windows_NT'">
    <Exec Command="for /d %%d in (&quot;$(TargetDir)*&quot;) do (
        if /i not &quot;%%~nxd&quot;==&quot;zh-CN&quot;
        if /i not &quot;%%~nxd&quot;==&quot;en-US&quot;
        if /i not &quot;%%~nxd&quot;==&quot;runtimes&quot;
        rd /s /q &quot;%%d&quot;
    )"/>
</Target>
```

## Conditions for GUI Projects

### Conditional Compilation

- `DEBUG;TRACE;NO_LICENSE` for Debug builds
- `TRACE;HAS_LICENSE` for Release builds

```xml
<PropertyGroup Condition="'$(Configuration)|$(Platform)' == 'Debug|x64'">
    <DefineConstants>DEBUG;TRACE;NO_LICENSE</DefineConstants>
</PropertyGroup>
```

### Package Dependencies

Core WPF dependencies:
- `WPF-UI` — Modern WPF controls library
- `CommunityToolkit.Mvvm` — MVVM source generators
- `Prism.Wpf` / `Prism.Core` — Navigation, regions
- `Dirkster.AvalonDock` — Docking window system
- `Serilog` + `Serilog.Sinks.Console` — Logging

## Icon Conventions

### Path Icon

For `MenuItem.Icon`, use `<Image>` element (not `<ui:SymbolIcon>`):

```xml
<MenuItem.Icon>
    <Image Source="/Resources/image/menu_icon.png"/>
</MenuItem.Icon>
```

### Toolbar Button Icon

Set icon geometry via `Tag` property:

```xml
<Button Style="{StaticResource ToolBarButton}"
        Tag="{StaticResource IconAdd}"
        Content="Button Text"/>
```

Icons are defined as `Geometry` resources in `AuroraIcons.xaml`.

## About Dialog

All GUI projects should use the shared `AboutButton` style:

```xml
<Button Style="{StaticResource AboutButton}"
        DockPanel.Dock="Right"
        Click="AboutButton_Click"
        Content="About"/>
```

This ensures consistent About dialog appearance across ControlPanel, DataBrowser, Telescope, VGPM, and ConfigEditor.
