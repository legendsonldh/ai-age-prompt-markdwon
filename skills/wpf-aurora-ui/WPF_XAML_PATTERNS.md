# WPF / XAML Patterns

## Project Architecture

### Solution Structure

```text
Solution.sln
├── *.Core/       # Shared models, interfaces, utilities (class libraries)
├── *.Controls/   # Shared WPF controls, converters, styles (class libraries)
├── *.GUI/        # Application projects (WinExe)
└── Test/         # NUnit test projects
```

### Dependency Flow

GUI projects reference Core/Controls projects. Core projects never reference GUI projects.

```
App ──> SharedWPFControls ──> CADECoreLib
App ──> License
```

## MVVM with CommunityToolkit.Mvvm

### ViewModel Pattern

Use source generators for clean ViewModels.

```csharp
public partial class MainViewModel : ObservableObject
{
    [ObservableProperty]
    private string? _userName;

    [ObservableProperty]
    private bool _isEnabled;

    // Auto-generated: UserName, IsEnabled properties with PropertyChanged

    [RelayCommand]
    private void DoSomething()
    {
        // Auto-generates DoSomethingCommand (ICommand)
    }

    // Property changed callback
    partial void OnIsEnabledChanged(bool value)
    {
        // Called when IsEnabled changes
    }
}
```

### Data Binding in XAML

```xml
<TextBox Text="{Binding UserName, Mode=TwoWay, UpdateSourceTrigger=PropertyChanged}"/>
<ToggleButton IsChecked="{Binding IsEnabled, Mode=TwoWay}"/>
<Button Command="{Binding DoSomethingCommand}" Content="Execute"/>
```

## Style Resolution

### Implicit vs Explicit Styles

- **Implicit** (`TargetType="Button"` without key): Applied automatically to all elements of that type
- **Explicit** (`x:Key="MyStyle"`): Applied via `Style="{StaticResource MyStyle}"`

**Key rule:** Explicit attribute values on elements override implicit style setters. To use an implicit DataGrid style, do NOT set `Background="Transparent"` or `BorderThickness="0"` on the element — these nullify the implicit style.

### BasedOn Chaining

```xml
<Style TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
    <!-- Extends default Button style -->
</Style>
```

`{StaticResource {x:Type Button}}` references the implicit default Button style.

## Resource Dictionaries

### Loading Order (App.xaml)

```xml
<Application.Resources>
    <ResourceDictionary>
        <ResourceDictionary.MergedDictionaries>
            <ui:ThemesDictionary Theme="Light"/>
            <ui:ControlsDictionary/>
            <ResourceDictionary Source="pack://application:,,,/SharedWPFControls;component/Styles/AuroraStyles.xaml"/>
            <ResourceDictionary Source="pack://application:,,,/SharedWPFControls;component/Styles/CategoryGrid.xaml"/>
            <!-- Project-specific overrides -->
            <ResourceDictionary Source="/Styles/AppStyles.xaml"/>
        </ResourceDictionary.MergedDictionaries>
    </ResourceDictionary>
</Application.Resources>
```

### Pack URI Format

Referencing resources from another assembly:
```
pack://application:,,,/AssemblyName;component/Path/To/File.xaml
```

## Converters

### Common Converter Types from SharedWPFControls

| Converter | Purpose |
|---|---|
| `IntToVisibilityConverter` | int → Visibility (with IsInverted option) |
| `BoolToBrushConverter` | bool → Brush (TrueBrush/FalseBrush) |

### Writing Custom Converters

```csharp
public class NullToVisibilityConverter : IValueConverter
{
    public bool IsInverted { get; set; }

    public object Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
    {
        bool isNull = value is null || (value is string s && string.IsNullOrEmpty(s));
        bool visible = IsInverted ? isNull : !isNull;
        return visible ? Visibility.Visible : Visibility.Collapsed;
    }

    public object ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
        => throw new NotSupportedException();
}
```

## DataGrid Patterns

### AuroraDataGrid Usage

```xml
<DataGrid ItemsSource="{Binding Items}"
          AutoGenerateColumns="False">
    <DataGrid.RowStyle>
        <Style TargetType="DataGridRow" BasedOn="{StaticResource {x:Type DataGridRow}}">
            <EventSetter Event="MouseLeftButtonUp" Handler="Row_Click"/>
        </Style>
    </DataGrid.RowStyle>
    <DataGrid.Columns>
        <DataGridTextColumn Header="Name" Width="4*" Binding="{Binding Name}"/>
        <DataGridTemplateColumn Header="Actions" Width="100">
            <DataGridTemplateColumn.CellTemplate>
                <DataTemplate>
                    <ToggleButton Style="{StaticResource GreenToggleSwitch}"
                                  IsChecked="{Binding Status, Mode=TwoWay}"/>
                </DataTemplate>
            </DataGridTemplateColumn.CellTemplate>
        </DataGridTemplateColumn>
    </DataGrid.Columns>
</DataGrid>
```

### Column Definitions

- `Width="4*"` (star sizing) for primary content columns
- `Width="100"` (fixed) for action/toggle columns
- Always define columns explicitly — never use `AutoGenerateColumns="True"`

## Dialog Patterns

### Window Properties

```xml
<Window WindowStartupLocation="CenterScreen"
        ResizeMode="NoResize"
        Background="{StaticResource SecondaryBackground}">
    <Window.Resources>
        <!-- Dialog-specific resources -->
    </Window.Resources>
    <Grid Margin="{StaticResource AuroraMarginLarge}">
        <!-- Content -->
    </Grid>
</Window>
```

### Tool/Dialog Cards

```xml
<ui:Card Style="{StaticResource UtilityCardStyle}">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>  <!-- Group name + toggle -->
            <RowDefinition Height="Auto"/>  <!-- Sub-items list -->
        </Grid.RowDefinitions>
    </Grid>
</ui:Card>
```

## Submodule References

When a project becomes a reusable dependency:

- Extract to separate repository
- Add as git submodule in parent repo
- Update `.csproj` ProjectReference paths
- Update `.sln` project paths
- Keep `AssemblyName` unchanged so XAML pack URIs still resolve
