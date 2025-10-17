# WBS5 UIC Usage Patterns

Guide for using Bootstrap 5 UIC (UI Components) in wnode applications.

## Overview

WBS5 UICs are wnode components that wrap Bootstrap 5 JavaScript components, providing:
- Server-side HTML generation with proper Bootstrap structure
- Client-side control methods for dynamic interaction
- Parameter validation and error handling
- Consistent API across components

## Basic UIC Pattern

### Import and Create
```javascript
// Import UIC group
const bs5UIC = importUIC('bs5:components')

// Create component in exports.view
const component = bs5UIC.create('componentType', 'componentId', parameters)
```

### General Structure
```javascript
exports.view = function(model, ctx) {
    const bs5UIC = importUIC('bs5:components')

    return xs.root('div')
        .add(
            bs5UIC.create('modal', 'myModal', {
                title: 'Modal Title',
                body: 'Modal content',
                size: 'large'
            })
        )
}

exports.control = function(c, model, ctx) {
    const modal = c.child('myModal')

    c.startup = function() {
        // Initialize component
        modal.show()
    }

    c.handleModalEvent = function() {
        modal.hide()
    }
}
```

## Available UIC Components

Based on source code analysis:

### 1. **Tab** - Tabbed interfaces
```javascript
bs5UIC.create('tab', 'id', {
    tabs: [
        {title: 'Tab 1', id: 'tab1', target: 'tab1', body: content, active: true}
    ],
    tabStyle: 'tabs' // 'tabs', 'pills', 'underline'
})
```

### 2. **Modal** - Dialog windows
```javascript
bs5UIC.create('modal', 'id', {
    title: 'Modal Title',
    body: content,
    footer: [buttons],
    size: 'large', // 'small', 'medium', 'large', 'xlarge'
    fullscreen: false
})
```

### 3. **Dropdown** - Dropdown menus
```javascript
bs5UIC.create('dropdown', 'id', {
    // Parameters from source analysis
})
```

### 4. **Accordion** - Collapsible sections
```javascript
bs5UIC.create('accordion', 'id', {
    // Parameters from source analysis
})
```

### 5. **Carousel** - Image/content sliders
```javascript
bs5UIC.create('carousel', 'id', {
    // Parameters from source analysis
})
```

## Control Method Patterns

### Common Methods
Most UICs provide these standard methods:

#### `show()` - Display component
```javascript
const component = c.child('componentId')
component.show()
```

#### `hide()` - Hide component
```javascript
component.hide()
```

#### `toggle()` - Toggle visibility
```javascript
component.toggle()
```

#### `on(event, handler)` - Event handling
```javascript
component.on('shown.bs.modal', function() {
    console.log('Modal shown')
})
```

### Component-Specific Methods

#### Tab Methods
```javascript
tabs.show(index)        // Show tab by index
tabs.activeTab()        // Get active tab title
```

#### Modal Methods
```javascript
modal.setTitle(title)   // Update modal title
modal.setBody(content)  // Update modal body
modal.config(options)   // Reconfigure modal
```

## Parameter Validation

UICs use wnode's `checkIn` validation system:

### Common Parameter Types
- **String validation**: `'@type': 'string'`
- **Enum validation**: `'@type': 'string{option1,option2}'`
- **Boolean validation**: `'@type': 'bool'`
- **Array validation**: `'@type': '[]'`
- **Required fields**: `'@required': true`
- **Default values**: `'@default': value`

### Error Handling
```javascript
// UICs return error alerts for invalid parameters
if (validation_fails) {
    return xs.div({class: 'alert alert-danger'}, 'Error message')
}
```

## Best Practices

### 1. Component Initialization
```javascript
exports.control = function(c, model, ctx) {
    c.startup = function() {
        // Access child components after DOM is ready
        const modal = c.child('modalId')
        if (modal) {
            // Initialize component state
        }
    }
}
```

### 2. Event Communication
```javascript
// Child to parent communication
c.handleComponentEvent = function(data) {
    c.notify('componentChanged', data)
}

// Component event handling
component.on('hidden.bs.modal', function() {
    c.notify('modalClosed')
})
```

### 3. Dynamic Content Updates
```javascript
c.updateComponent = function(newData) {
    const modal = c.child('modalId')
    modal.setTitle(newData.title)
    modal.setBody(newData.content)
}
```

### 4. Proper Parameter Structure
```javascript
// Good - well-structured parameters
const params = {
    title: 'Clear Title',
    size: 'large',
    body: contentElement,
    footer: [saveButton, cancelButton]
}

// Bad - unclear or missing parameters
const params = {
    content: 'Mixed content type'
}
```

### 5. Error Prevention
```javascript
// Validate parameters before creating UIC
if (!model.tabs || !Array.isArray(model.tabs)) {
    return xs.div({class: 'alert alert-warning'}, 'No tab data available')
}

const tabs = bs5UIC.create('tab', 'myTabs', {
    tabs: model.tabs,
    tabStyle: 'tabs'
})
```

## Integration with Palets

### Embedding Palets in UICs
```javascript
const settingXS = require('./setting.xs')

const tabs = bs5UIC.create('tab', 'settingsTabs', {
    tabs: [
        {
            title: 'Settings',
            id: 'settingsTab',
            target: 'settingsTab',
            body: settingXS.create('settingPane', {websiteId: model.websiteId}),
            active: true
        }
    ]
})
```

### UIC Event Forwarding
```javascript
exports.control = function(c, model, ctx) {
    // Forward events from embedded palets
    c.onSettingChanged = function(settingData) {
        c.notify('settingChanged', settingData)
    }

    // Handle UIC events
    const tabs = c.child('settingsTabs')
    tabs.on('shown.bs.tab', function(e) {
        const activeTab = tabs.activeTab()
        c.notify('tabChanged', {activeTab})
    })
}
```

## Performance Considerations

### 1. Lazy Loading
```javascript
c.loadTabContent = function(tabIndex) {
    // Load content only when tab is activated
    if (!c.tabLoaded[tabIndex]) {
        const content = heavyContentXS.create('content', params)
        tabs.setTabContent(tabIndex, content)
        c.tabLoaded[tabIndex] = true
    }
}
```

### 2. Component Cleanup
```javascript
c.destroy = function() {
    // Clean up component resources
    const modal = c.child('modalId')
    if (modal) {
        modal.hide()
    }
}
```

## Debugging UICs

### 1. Parameter Validation
Check console for UIC validation errors and ensure all required parameters are provided.

### 2. DOM Structure
Use browser dev tools to inspect generated Bootstrap HTML structure.

### 3. Event Debugging
```javascript
component.on('all.bs.events', function(e) {
    console.log('Component event:', e.type, e)
})
```

This comprehensive guide covers the essential patterns for using WBS5 UICs effectively in wnode applications.