# Input Dialog (lib.inputDialog)

Use this rule when creating forms to collect user input with ox_lib.

## lib.inputDialog

Opens a modal dialog with configurable input fields. Returns a table of values or `nil` if cancelled.

```lua
local input = lib.inputDialog(heading, rows, options)
```

### Parameters

| Field | Type | Description |
|-------|------|-------------|
| heading | `string` | Dialog title |
| rows | `string[]` or `table[]` | Input field definitions |
| options | `table` | Optional dialog settings |

### Options

| Field | Type | Description |
|-------|------|-------------|
| allowCancel | `boolean` | If `false`, user cannot cancel |
| size | `string` | `"xs"`, `"sm"`, `"md"`, `"lg"`, `"xl"` |

## Field Types

### input

```lua
{type = 'input', label = 'Name', description = 'Enter your name', placeholder = 'John Doe', icon = 'user', required = true, min = 2, max = 50, default = 'Guest', password = false}
```

### number

```lua
{type = 'number', label = 'Age', description = 'Your age', placeholder = '25', icon = 'hashtag', required = true, min = 18, max = 120, default = 18, precision = 0, step = 1}
```

### checkbox

```lua
{type = 'checkbox', label = 'I agree to terms', checked = false, disabled = false, required = true}
```

### select / multi-select

```lua
{type = 'select', label = 'Department', options = {
    {value = 'police', label = 'Police Department'},
    {value = 'ems', label = 'EMS'},
}, description = 'Select your dept', placeholder = 'Choose...', icon = 'building', required = true, default = 'police', clearable = true, searchable = true}
```

For `multi-select`: `default` can be a table of values, `maxSelectedValues` limits selections.

### slider

```lua
{type = 'slider', label = 'Volume', placeholder = '0-100', icon = 'volume-high', required = false, default = 50, min = 0, max = 100, step = 5}
```

### color

```lua
{type = 'color', label = 'Favorite Color', description = 'Pick a color', icon = 'palette', required = false, default = '#eb4034', format = 'hex'}
```

Formats: `'hex'`, `'hexa'`, `'rgb'`, `'rgba'`, `'hsl'`, `'hsla'`.

### date

```lua
{type = 'date', label = 'Birth Date', icon = {'far', 'calendar'}, required = false, default = true, format = 'DD/MM/YYYY', returnString = false, clearable = true, min = '01/01/1900', max = '01/01/2024'}
```

`default = true` sets to current date. Returns Unix timestamp by default; `returnString = true` returns formatted string.

### date-range

```lua
{type = 'date-range', label = 'Vacation', icon = 'calendar-days', required = false, default = {'01/01/2024', '07/01/2024'}, format = 'DD/MM/YYYY', returnString = false, clearable = true}
```

### time

```lua
{type = 'time', label = 'Meeting Time', description = 'Select time', icon = 'clock', required = false, default = '14:30', format = '24', clearable = true}
```

Formats: `'12'` or `'24'`.

### textarea

```lua
{type = 'textarea', label = 'Notes', description = 'Additional info', placeholder = 'Type here...', icon = 'note-sticky', required = false, default = '', min = 3, max = 10, autosize = true, minLength = 10, maxLength = 500}
```

## Control Functions

```lua
-- Force close the active input dialog (returns nil)
lib.closeInputDialog()
```

## Examples

### Basic

```lua
local input = lib.inputDialog('Basic dialog', {'First row', 'Second row'})
if not input then return end
print(input[1], input[2])
```

### Advanced

```lua
local input = lib.inputDialog('Police Report', {
    {type = 'input', label = 'Suspect Name', required = true, min = 2, max = 50},
    {type = 'number', label = 'Fine Amount', icon = 'dollar-sign', min = 0, max = 10000},
    {type = 'select', label = 'Charge', options = {
        {value = 'speeding', label = 'Speeding'},
        {value = 'theft', label = 'Theft'},
    }, required = true},
    {type = 'checkbox', label = 'Warrant issued'},
    {type = 'color', label = 'Marker Color', default = '#ff0000'},
    {type = 'date', label = 'Incident Date', icon = {'far', 'calendar'}, default = true, format = 'DD/MM/YYYY'},
})

if not input then return end

local suspectName = input[1]
local fineAmount = input[2]
local charge = input[3]
local warrant = input[4]
local markerColor = input[5]
local incidentDate = input[6]

-- Convert color to RGBA
local rgba = lib.math.torgba(markerColor)

-- Convert date timestamp
local timestamp = math.floor(incidentDate / 1000)
local dateStr = os.date('%Y-%m-%d %H:%M:%S', timestamp)
```

## Important Notes

- The function is promise-based; execution pauses until user submits or cancels
- Return values are indexed by row position (1-based in Lua)
- `date`, `date-range`, and `time` return Unix timestamps by default
- Always check for `nil` return (user cancelled)
