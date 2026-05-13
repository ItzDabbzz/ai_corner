# Notifications (lib.notify)

Use this rule when creating or styling notifications in FiveM with ox_lib.

## lib.notify

Client-side notification with rich styling options.

```lua
lib.notify(data)
```

Server-side (triggers on client):

```lua
TriggerClientEvent('ox_lib:notify', source, data)
```

## Parameters

| Field | Type | Description |
|-------|------|-------------|
| id | `string` | Unique identifier; prevents duplicate spam |
| title | `string` | Required if no description |
| description | `string` | Required if no title; supports markdown |
| duration | `number` | Default: `3000` (ms) |
| showDuration | `boolean` | Default: `true` |
| position | `string` | `'top'`, `'top-right'`, `'top-left'`, `'bottom'`, `'bottom-right'`, `'bottom-left'`, `'center-right'`, `'center-left'` |
| type | `string` | `'inform'`, `'error'`, `'success'`, `'warning'` |
| style | `table` | React CSS styling format |
| icon | `string` | Font Awesome 6 icon name |
| iconColor | `string` | CSS color value |
| iconAnimation | `string` | `'spin'`, `'spinPulse'`, `'spinReverse'`, `'pulse'`, `'beat'`, `'fade'`, `'beatFade'`, `'bounce'`, `'shake'` |
| alignIcon | `string` | `'top'` or `'center'` (default: `'center'`) |
| sound | `table` | `{ bank = 'string', set = 'string', name = 'string' }` |

Setting `iconColor` removes the default contrasted icon color and circular background.

## Examples

### Standard

```lua
lib.notify({
    title = 'Notification title',
    description = 'Notification description',
    type = 'success'
})
```

### Custom styled

```lua
lib.notify({
    id = 'some_identifier',
    title = 'Notification title',
    description = 'Notification description',
    showDuration = false,
    position = 'top',
    style = {
        backgroundColor = '#141517',
        color = '#C1C2C5',
        ['.description'] = {
            color = '#909296'
        }
    },
    icon = 'ban',
    iconColor = '#C53030'
})
```

### Server to client

```lua
-- Server
TriggerClientEvent('ox_lib:notify', source, {
    title = 'Payment Received',
    description = 'You received $500',
    type = 'success'
})
```
