# Tab UIC Component

Bootstrap 5 Tab UIC component for creating tabbed interfaces in wnode applications.

## Basic Usage

```javascript
const bs5UIC = importUIC('bs5:components')

// In exports.view
const tabComponent = bs5UIC.create('tab', 'myTabs', {
    tabs: [
        {
            title: 'Tab 1',
            id: 'tab1',
            target: 'tab1',
            body: content1,
            active: true
        },
        {
            title: 'Tab 2',
            id: 'tab2',
            target: 'tab2',
            body: content2
        }
    ],
    tabStyle: 'tabs'
})
```

## Parameters

### Required Parameters

#### `tabs` (Array)
Array of tab objects. Each tab object supports:

- **`title`** (String|Element) - Required. Tab label text or element
- **`id`** (String) - Required. Unique identifier for the tab pane
- **`target`** (String) - Required. CSS ID for Bootstrap tab navigation (should match `id`)
- **`body`** (Element) - Required. Tab content (can be embedded palets)
- **`active`** (Boolean) - Optional. Set to `true` for the initially active tab
- **`disabled`** (Boolean) - Optional. Set to `true` to disable the tab

### Optional Parameters

#### `tabStyle` (String)
Tab appearance style. Options:
- `'tabs'` (default) - Standard Bootstrap tabs
- `'pills'` - Bootstrap pill-style tabs
- `'underline'` - Underlined tabs

#### `tabColor` (String)
Custom color for active tabs (CSS color value)

#### `sideway` (String)
For vertical tab layouts. Can be `"vtabs left-tabs"`

## Control Methods

Available methods on the tab controller:

### `show(idx)`
Show the tab at the specified index (0-based)
```javascript
const tabs = c.child('myTabs')
tabs.show(1) // Show second tab
```

### `activeTab()`
Returns the title of the currently active tab
```javascript
const activeTitle = tabs.activeTab()
```

### `on(eventName, handler)`
Register event handler on all tab links
```javascript
tabs.on('click', function() {
    console.log('Tab clicked')
})
```

## Real-World Examples

### Basic Settings Tabs
```javascript
exports.view = function(model, ctx) {
    const bs5UIC = importUIC('bs5:components')
    const generalXS = require('./general.xs')
    const securityXS = require('./security.xs')

    return xs.root('div')
        .add(
            bs5UIC.create('tab', 'settingsTabs', {
                tabs: [
                    {
                        title: 'General',
                        id: 'generalTab',
                        target: 'generalTab',
                        body: generalXS.create('generalSettings', model.general),
                        active: true
                    },
                    {
                        title: 'Security',
                        id: 'securityTab',
                        target: 'securityTab',
                        body: securityXS.create('securitySettings', model.security)
                    }
                ],
                tabStyle: 'tabs'
            })
        )
}
```

### Pill-Style Tabs with Custom Color
```javascript
const tabs = bs5UIC.create('tab', 'styleTabs', {
    tabs: [
        {
            title: 'Overview',
            id: 'overview',
            target: 'overview',
            body: overviewContent,
            active: true
        },
        {
            title: 'Details',
            id: 'details',
            target: 'details',
            body: detailsContent
        }
    ],
    tabStyle: 'pills',
    tabColor: '#28a745'
})
```

### Vertical Tabs
```javascript
const verticalTabs = bs5UIC.create('tab', 'verticalTabs', {
    tabs: tabData,
    tabStyle: 'tabs',
    sideway: 'vtabs left-tabs'
})
```

### Dynamic Tab Control
```javascript
exports.control = function(c, model, ctx) {
    const tabs = c.child('myTabs')

    c.startup = function() {
        // Show specific tab based on model data
        if (model.activeTabIndex) {
            tabs.show(model.activeTabIndex)
        }
    }

    c.switchToSecondTab = function() {
        tabs.show(1)
    }

    c.getCurrentTab = function() {
        return tabs.activeTab()
    }

    // Handle tab switch events
    tabs.on('shown.bs.tab', function(e) {
        const activeTab = tabs.activeTab()
        c.notify('tabChanged', { activeTab })
    })
}
```

## Error Handling

The Tab UIC includes built-in validation:
- Checks that `tabs` parameter is an array
- Validates that each tab has a `title` property
- Shows error alert if validation fails

```javascript
// Error display example
if (model.tabs.some(tab => !isObject(tab) || !tab.title)) {
    return xs.div({class: 'alert'},
        'BS5-UIC-Tab: The tab property should be an array of objects with each object having the title property.')
}
```

## Best Practices

1. **Always provide unique IDs**: Each tab must have a unique `id` and matching `target`
2. **Set one active tab**: Only one tab should have `active: true`
3. **Use meaningful titles**: Tab titles should clearly describe their content
4. **Handle tab events**: Listen for tab changes to update application state
5. **Embed palets properly**: Use `paletXS.create()` pattern for tab content
6. **Validate tab data**: Check tab configuration before creating the component

## CSS Customization

The Tab UIC includes built-in CSS:
- `.tab-pane` - Scrollable tab content containers
- `.nav-link.active` - Active tab styling with customizable background color

Custom styling can be applied through the `tabColor` parameter or additional CSS rules.