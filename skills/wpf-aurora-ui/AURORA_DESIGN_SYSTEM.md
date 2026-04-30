# Aurora Design System

## Color Palette

All colors are defined as `SolidColorBrush` resources in `AuroraColors.xaml`.

### Semantic Colors

| Resource Key | Value | Usage |
|---|---|---|
| `PrimaryBackground` | `#0078D4` | Primary buttons, accent color |
| `PrimaryForeground` | `#FFFFFF` | Text on primary surfaces |
| `SecondaryBackground` | `#F3F3F3` | Window/page background |
| `SurfaceBackground` | `#F4F7FB` | General surface background |
| `SurfaceRaisedBackground` | `#FFFFFF` | Cards, dialogs, raised surfaces |
| `SurfaceMutedBackground` | `#EEF3F8` | Subdued card sections |
| `SurfaceBorder` | `#DCE5EF` | Default border color |
| `TextPrimary` | `#1A1A1A` | Primary text |
| `TextSecondary` | `#5E5E5E` | Secondary/body text |
| `TextMuted` | `#667085` | Muted/label text |
| `TextTertiary` | `#8A8886` | Placeholder/disabled text |

### Status Colors

| Resource Key | Value | Usage |
|---|---|---|
| `AuroraGreen` | `#107C10` | Success, ON state, green toggle |
| `AuroraRed` | `#C42B1C` | Error, OFF critical |
| `AuroraYellow` | `#F9A825` | Warning |
| `SuccessBackground` | `#107C10` | Success button background |
| `SuccessBrush` | `#107C10` | Success brush reference |
| `SuccessColor` | `#107C10` | Success color (for DropShadowEffect) |
| `WarningBackground` | `#F9A825` | Warning background |
| `ErrorBackground` | `#C42B1C` | Error background |

### Toggle Colors

| Resource Key | Value | Usage |
|---|---|---|
| `ToggleButtonOn` | `#0078D4` | Toggle ON (default blue) |
| `ToggleButtonOff` | `#8A8886` | Toggle OFF |

### Miscellaneous

| Resource Key | Value | Usage |
|---|---|---|
| `DataGridHeaderBackground` | `#F5F5F5` | DataGrid column headers |
| `DataGridCellBackground` | `#FFFFFF` | DataGrid cells |
| `DataGridCellSelectedBackground` | `#E5F1FB` | DataGrid selected row |
| `TextBoxBackground` | `#FFFFFF` | Text input background |
| `ComboBoxBackground` | `#FFFFFF` | Dropdown background |

## Sizing Tokens

Defined in `AuroraSizes.xaml`.

### Button Sizes

| Key | Value | Usage |
|---|---|---|
| `AuroraButtonHeightNormal` | 36 | Standard button height |
| `AuroraButtonHeightSmall` | 30 | Small button height |
| `AuroraButtonHeightMini` | 25 | Mini button height |
| `AuroraButtonWidthLarge` | 120 | Wide button (Save As, etc.) |
| `AuroraButtonWidthNormal` | 100 | Standard button (OK, Cancel) |
| `AuroraButtonWidthSmall` | 90 | Small button |
| `AuroraButtonWidthMini` | 60 | Mini button |
| `AuroraButtonWidthIcon` | 36 | Icon-only button width |
| `AuroraButtonWidthIconSmall` | 30 | Small icon button width |
| `AuroraButtonSizeIcon` | 36 | Square icon button |
| `AuroraButtonSizeIconSmall` | 30 | Small square icon button |

### Action Card Sizes

| Key | Value |
|---|---|
| `AuroraActionCardWidth` | 410 |
| `AuroraActionCardHeight` | 120 |

## Spacing Tokens

Defined in `AuroraSpacing.xaml`. Uses a 2/4/5/6/8/10/12/16/20/24 progression.

### Margins (Thickness resources)

Pattern: `AuroraMargin{Direction}{Size}`

| Key | Value |
|---|---|
| `AuroraMarginMedium` | 8 (uniform) |
| `AuroraMarginLarge` | 10 (uniform) |
| `AuroraMarginXLarge` | 12 (uniform) |
| `AuroraMarginLeft` | 8,0,0,0 |
| `AuroraMarginRight` | 0,0,8,0 |
| `AuroraMarginRightXXLarge` | 0,0,16,0 |
| `AuroraMarginTop` | 0,10,0,0 |
| `AuroraMarginBottom` | 0,0,0,6 |

### Padding

| Key | Value |
|---|---|
| `AuroraPaddingMedium` | 8 |
| `AuroraPaddingLarge` | 10 |
| `AuroraPaddingXLarge` | 12 |
| `AuroraPaddingContent` | 12,10 |

### Font Sizes

| Key | Value | Usage |
|---|---|---|
| `AuroraFontSizeBody` | 12 | General body text |
| `AuroraFontSizeBodyLarge` | 13 | Slightly larger body |
| `AuroraFontSizeSubtitle` | 14 | Section subtitles |
| `AuroraFontSizeTitle` | 16 | Card/section titles |
| `AuroraFontSizeHeading` | 20 | Page headings |
| `AuroraFontSizeCaption` | 11 | Status bar, labels |

### Corner Radius

| Key | Value |
|---|---|
| `AuroraCornerLarge` | 6 |
| `AuroraCornerXLarge` | 8 |
| `AuroraCornerRound` | 10 |
| `AuroraCornerPill` | 12 |

### Icon Sizes

| Key | Value |
|---|---|
| `AuroraIconSizeMedium` | 14 |
| `AuroraIconSizeLarge` | 16 |
| `AuroraIconSizeXLarge` | 18 |

### Standard Heights

| Key | Value |
|---|---|
| `AuroraHeightStatusDot` | 8 |
| `AuroraHeightGridSplitter` | 4 |

### Opacity

| Key | Value |
|---|---|
| `AuroraOpacityDisabled` | 0.5 |
| `AuroraOpacitySubtle` | 0.6 |
| `AuroraOpacityMedium` | 0.3 |
| `AuroraOpacityLight` | 0.15 |

## Resource Loading Order

Aurora resource dictionaries must be loaded in dependency order:

1. `AuroraColors.xaml` — All brush/color definitions
2. `AuroraSizes.xaml` — Dimension constants
3. `AuroraSpacing.xaml` — Margin/padding/font/corner tokens
4. `AuroraIcons.xaml` — Shared icon geometries
5. `AuroraBase.xaml` — Base layout templates
6. `AuroraCardButton.xaml` — Card button styles
7. `Button.xaml` — All button/toggle styles
8. `ConsoleStyles.xaml` — Console/log styles
9. `AuroraDataGrid.xaml` — DataGrid implicit style

All are loaded via `SharedWPFControls/Styles/AuroraStyles.xaml` (merged dictionary).
