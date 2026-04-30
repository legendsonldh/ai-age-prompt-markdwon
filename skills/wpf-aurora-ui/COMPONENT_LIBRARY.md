# Aurora Component Library

## ToolBarButton

Icon+text toolbar button with hover/pressed states. Icon geometry is set via the `Tag` property.

```xml
<Button Style="{StaticResource ToolBarButton}"
        Tag="{StaticResource IconAdd}"
        Content="Add Watch"/>
```

- `CornerRadius="8"`
- 28px icon (from Tag geometry), white fill
- Text follows content
- Hover: subtle background lift; Pressed: darker background

## LoggerToolBarButton

Extends `ToolBarButton` with a green→red toggle for logging state. Uses `IsDataLogging` property to switch.

```xml
<Button Style="{StaticResource LoggerToolBarButton}"
        Click="LoggerButton_Click"
        Content="Start Logging"/>
```

- ON (logging): green icon
- OFF (idle): red icon
- Icon geometry: `IconLogger` / `IconLoggerActive` from `AuroraIcons.xaml`

## GreenToggleSwitch

iOS-style pill toggle (48×26). Green (`#107C10`) when checked, gray (`#B0B0B0`) when unchecked. White round thumb with subtle shadow.

```xml
<ToggleButton Style="{StaticResource GreenToggleSwitch}"
              IsChecked="{Binding IsEnabled, Mode=TwoWay}"/>
```

Used for:
- Header-level VGPM item enable/disable
- Partition-level ON/OFF in DataGrid cells
- Utility group master switches
- Any boolean ON/OFF control

## AuroraButton Styles

Standard button sizes — prefer these over manual Width/Height.

| Style Key | Size | Usage |
|---|---|---|
| `AuroraButtonNormal` | 100×36 | Standard action button |
| `AuroraButtonLarge` | 120×36 | Primary action (Save, Generate) |
| `AuroraButtonSmall` | 90×30 | Secondary/inline action |
| `AuroraButtonIcon` | 36×36 | Square icon button |
| `AuroraButtonIconSmall` | 30×25 | Mini icon button |

```xml
<Button Style="{StaticResource AuroraButtonNormal}"
        Content="确定"/>
```

## ToolBarFieldLabel

Label text for toolbar fields (combo boxes, etc.). 11px, `TextSecondary` color.

```xml
<TextBlock Text="Data" Style="{StaticResource ToolBarFieldLabel}"/>
<ComboBox ItemsSource="{Binding DataFormatList}" .../>
```

## AboutButton

Unified about dialog button across all GUI projects.

```xml
<Button Style="{StaticResource AboutButton}"
        DockPanel.Dock="Right"
        Click="AboutButton_Click"
        Content="About"/>
```

## AuroraDataGrid

Standard DataGrid style applied implicitly to all DataGrid elements.

```xml
<DataGrid ItemsSource="{Binding Items}"
          AutoGenerateColumns="False">
    <DataGrid.Columns>
        <DataGridTextColumn Header="Name" Binding="{Binding Name}"/>
        <DataGridTemplateColumn Header="Actions">...</DataGridTemplateColumn>
    </DataGrid.Columns>
</DataGrid>
```

Key characteristics:
- Light background (`#FFFFFF` cells, `#F5F5F5` headers)
- Full-row selection with blue highlight (`#E5F1FB`)
- Clean borders, no gridlines
- **Must set `AutoGenerateColumns="False"`** to avoid extra blank columns
- Do NOT set `Background="Transparent"` or `BorderThickness="0"` — these override the implicit style

### Selection Style (DataBrowser variant)

For DataGrids requiring prominent row selection:
- Selected row: background `#B5D2F0`, 3px blue left border, `SemiBold` text
- `SelectionMode="Single"`, `SelectionUnit="FullRow"`
- Cell background `Transparent` when selected (lets row color show through)

## AuroraCard

Card-style container (`ui:Card` or bordered `Border`).

```xml
<!-- Using ui:Card -->
<ui:Card Width="370" Style="{StaticResource UtilityCardStyle}">
    <Grid>...</Grid>
</ui:Card>

<!-- Using Border -->
<Border CornerRadius="8" Padding="16"
        Background="{StaticResource SurfaceRaisedBackground}"
        BorderBrush="{StaticResource SurfaceBorder}" BorderThickness="1">
    <Grid>...</Grid>
</Border>
```

### Monitor Card (VGPM CPM pages)

```xml
<Border Style="{StaticResource AuroraMonitorCard}">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>  <!-- Header -->
            <RowDefinition Height="*"/>      <!-- Content -->
        </Grid.RowDefinitions>
        <!-- Card Header with title + toggle -->
        <!-- DataGrid or empty state -->
    </Grid>
</Border>
```

## Empty State Pattern

Used when a collection has no items.

```xml
<StackPanel VerticalAlignment="Center" HorizontalAlignment="Center"
            Visibility="{Binding SomeCount, Converter={StaticResource IntToVis}}">
    <ui:SymbolIcon Symbol="Prohibited24" FontSize="28"
                   Foreground="{StaticResource TextTertiary}"/>
    <TextBlock Text="No items available"
               Style="{StaticResource EmptyStateTextBlock}"/>
</StackPanel>
```

## Status Indicator Dot

Small colored ellipse showing running/stopped state.

```xml
<Ellipse Width="{StaticResource AuroraHeightStatusDot}"
         Height="{StaticResource AuroraHeightStatusDot}"
         Fill="{Binding IsRunning, Converter={StaticResource BoolToBrushConverter}}"
         VerticalAlignment="Center"/>
```

With `BoolToBrushConverter`:
```xml
<local1:BoolToBrushConverter x:Key="BoolToBrushConverter"
    TrueBrush="{StaticResource ToggleButtonOn}"
    FalseBrush="{StaticResource ToggleButtonOff}"/>
```

## Console Log Styles (ConsoleStyles.xaml)

| Resource | Usage |
|---|---|
| `ConsoleCellTextStyle` | Log cell with DataTrigger on Level (Error=Red, Warning=Orange, Info=Blue) |
| `ConsoleRowStyle` | Row template with alternate background |
| `ValueCellStyle` | Cell with right-aligned monospace value |
| `DataGridCellTransparentStyle` | Transparent cell background |
| `DataGridRowStyle` | Standard row with selection highlight |
