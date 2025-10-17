# WBS5 UIC Components Reference

Bootstrap 5 UI Components (UICs) for wnode applications.

## Available Components

### 1. [Tab](./tab.md) - Tabbed Interfaces
Create Bootstrap tab navigation with content panels.

```javascript
bs5UIC.create('tab', 'myTabs', {
    tabs: [
        {title: 'Tab 1', id: 'tab1', target: 'tab1', body: content, active: true}
    ],
    tabStyle: 'tabs' // 'tabs', 'pills', 'underline'
})
```

**Control Methods**: `show(index)`, `activeTab()`, `on(event, handler)`

### 2. [Modal](./modal.md) - Dialog Windows
Create Bootstrap modal dialogs for forms, confirmations, and content display.

```javascript
bs5UIC.create('modal', 'myModal', {
    title: 'Modal Title',
    body: content,
    footer: [buttons],
    size: 'large'
})
```

**Control Methods**: `show()`, `hide()`, `toggle()`, `setTitle()`, `setBody()`, `setFooter()`, `config()`

### 3. Accordion - Collapsible Sections
Create Bootstrap accordion components with expandable sections.

```javascript
bs5UIC.create('accordion', 'myAccordion', {
    items: [
        {header: 'Section 1', body: content1, show: true},
        {header: 'Section 2', body: content2, show: false}
    ],
    flush: false,
    alwaysOpen: false
})
```

**Control Methods**: `openItem(index)`, `closeItem(index)`, `closeAll()`

### 4. Dropdown - Dropdown Menus
Create Bootstrap dropdown menus.

```javascript
bs5UIC.create('dropdown', 'myDropdown', {
    // Parameters based on source analysis
})
```

### 5. Carousel - Image/Content Sliders
Create Bootstrap carousel components for image galleries and content rotation.

```javascript
bs5UIC.create('carousel', 'myCarousel', {
    // Parameters based on source analysis
})
```

## Quick Start

### 1. Import UIC Group
```javascript
const bs5UIC = importUIC('bs5:components')
```

### 2. Create Component in View
```javascript
exports.view = function(model, ctx) {
    return xs.root('div')
        .add(
            bs5UIC.create('componentType', 'componentId', parameters)
        )
}
```

### 3. Control Component in Controller
```javascript
exports.control = function(c, model, ctx) {
    const component = c.child('componentId')

    c.startup = function() {
        component.show() // or other methods
    }
}
```

## Common Patterns

### Parameter Validation
All UICs use wnode's `checkIn` validation system:
- Required parameters: `'@required': true`
- Type validation: `'@type': 'string'`, `'@type': 'bool'`, `'@type': '[]'`
- Enum validation: `'@type': 'string{option1,option2}'`
- Default values: `'@default': value`

### Event Handling
```javascript
// Register component events
component.on('eventName', function(e) {
    console.log('Component event:', e)
})

// Handle component state changes
component.on('shown.bs.modal', function() {
    c.notify('componentShown')
})
```

### Dynamic Content Updates
```javascript
// Update component content
component.setTitle('New Title')
component.setBody(newContent)

// Reload with new parameters
c.reload(newParams, function() {
    console.log('Component reloaded')
})
```

### Embedding Palets
```javascript
// Embed palets in UIC components
const paletXS = require('./palet.xs')
const component = bs5UIC.create('tab', 'tabs', {
    tabs: [
        {
            title: 'Settings',
            body: paletXS.create('settingPane', params),
            active: true
        }
    ]
})
```

## Best Practices

### 1. Component Lifecycle
- Initialize components in `c.startup()`
- Clean up in `c.destroy()`
- Handle events properly

### 2. Parameter Management
- Validate parameters before creating components
- Use meaningful component IDs
- Provide default values where appropriate

### 3. Event Communication
- Use `c.notify()` for parent communication
- Register component events for state tracking
- Forward relevant events from embedded palets

### 4. Error Handling
- Check for component existence before calling methods
- Handle UIC validation errors gracefully
- Provide fallback content for failed components

### 5. Performance
- Load content dynamically when needed
- Clean up event listeners
- Avoid recreating components unnecessarily

## Documentation

For detailed documentation on each component:
- **[General Usage Patterns](./usage_patterns.md)** - Common UIC patterns and best practices
- **[Tab Component](./tab.md)** - Complete tab UIC documentation
- **[Modal Component](./modal.md)** - Complete modal UIC documentation

## Source Code

UIC source code is available at:
- `doc/src/uic/bs5/components/` - Individual component implementations
- Components include: `tab.xs`, `modal.xs`, `accordion.xs`, `dropdown.xs`, `carousel.xs`

## Integration with wnode

UICs integrate seamlessly with the wnode framework:
- Follow standard wnode component patterns
- Support parameter validation through `checkIn`
- Provide both server-side HTML generation and client-side control
- Work with wnode's event system and component embedding

For more information, see the [WBS5 Bootstrap Integration Guide](../wbs5_bootstrap_integration.md).