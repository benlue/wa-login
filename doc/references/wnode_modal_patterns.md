# wnode Modal Dialog Patterns

This document describes the standard patterns for implementing Bootstrap 5 modal dialogs in wnode projects using the wbs5 framework.

## Overview

There are three main patterns for implementing modals in wnode:

1. **Empty Modal with Dynamic Palet Loading** - For complex, reusable content
2. **Static Content Modal** - For simple dialogs with fixed content  
3. **Component-based Modal** - Using dedicated modal components (like strongWarning.xs)

## Pattern 1: Empty Modal with Dynamic Palet Loading

This is the most common pattern for complex modals that need to load different content dynamically.

### 1.1 Modal Creation in exports.view

```javascript
// Generate empty modal in view function
function genSplitModal() {
    const config = {
        title: xs.div({class: 'text-center fs-3'}, '<i class="bi bi-exclamation-circle-fill text-warning pe-2"></i> 分段管理'),
        body: xs.div(),           // Empty body - content loaded dynamically
        backdrop: 'static',       // Prevent closing by clicking outside
        dismiss: true,           // Show X close button
        size: 'medium'          // Modal size: small, medium, large, xlarge
    }

    return bs5UIC.create('modal', 'splitModalCssID', config)
}

// Add modal to page
exports.view = function(model) {
    let root = xs.root(css())
              .add('div', {class: 'content'}, getContent())
              .add(genSplitModal())  // Add empty modal
    
    return root
}
```

### 1.2 Modal Activation in exports.control

```javascript
exports.control = function(p) {
    
    p.showSplit = function(post) {
        const modalPL = p.child('splitModalCssID')
        
        // Load palet into modal body
        modalPL.setBodyPalet('paletID', '/path/to/modal/palet', post, emCtrl => {
            // Register events from the loaded palet
            // NOTE: These events are custom and defined by each modal body palet
            // Common patterns include 'finish', 'cancel', 'save', 'close', etc.
            emCtrl.on('finish', function() {
                modalPL.hide()
                p.child('listComponent').reload()  // Refresh parent data
            })
            
            emCtrl.on('cancel', function() {
                modalPL.hide()
            })

            modalPL.show()  // Show modal after palet is loaded
        })
    }
}
```

**Important Notes:**
- **Custom Events**: The events like `'finish'` and `'cancel'` are not standard - they are custom events that each modal body palet may choose to emit via `p.notify()`
- **Event Discovery**: Check the modal body palet's `exports.control` function to see what events it emits
- **Event Naming**: Common patterns include `'finish'`, `'save'`, `'cancel'`, `'close'`, `'submit'`, but each palet defines its own
- **Optional Events**: Modal body palets may not emit any events at all - they might handle everything internally

### 1.3 Event Triggering from Child Components

```javascript
// In child component (like list.xs)
function getActionButton(item) {
    return xs.e('button', {
        class: 'btn btn-primary my-split',
        'data-inid': item.id
    }, '分段').on('click', 'this.triggerSplit')
}

exports.control = function(p) {
    function showSplit(e) {
        const btn = $(this)
        const id = btn.data('inid')
        
        // Notify parent to show modal
        p.notify('showSplit', {inID: id})
    }
    
    // Bind event handlers
    p.startup = function() {
        p.find('.my-split').on('click', showSplit)
    }
}
```

## Pattern 2: Static Content Modal

For simple modals with predefined content that doesn't change.

### 2.1 Direct Modal Creation

```javascript
// Create modal with static content
function createInfoModal() {
    return bs5UIC.create('modal', 'infoModalCssID', {
        title: '資訊',
        body: xs.div({}, [
            xs.e('p', '這是靜態內容'),
            xs.e('p', '不需要動態載入')
        ]),
        footer: [
            xs.e('button', {
                type: 'button',
                class: 'btn btn-secondary',
                'data-bs-dismiss': 'modal'
            }, '關閉'),
            xs.e('button', {
                type: 'button', 
                class: 'btn btn-primary'
            }, '確定').on('click', 'this.confirm')
        ],
        dismiss: true,
        size: 'medium'
    })
}
```

### 2.2 Modal Control

```javascript
exports.control = function(p) {
    p.showInfo = function() {
        const modal = p.child('infoModalCssID')
        modal.show()
    }
    
    p.confirm = function() {
        const modal = p.child('infoModalCssID')
        modal.hide()
        // Perform confirmation action
    }
}
```

## Pattern 3: Component-based Modal

Using dedicated modal components for reusable modal dialogs.

### 3.1 Component Usage

```javascript
// Import modal component
const stWarningXS = require('/kit/tools/strongWarning.xs')

exports.view = function(model) {
    // Create modal component instance
    let platformWarning = stWarningXS.create('warningCssID', {
        title: '設定警示', 
        content: '字軌共用設定', 
        doubleCheck: true, 
        checkLabel: '我已了解字軌設定後將無法進行變更'
    }).on('confirm', 'this.doPlatform')

    return xs.root().add(content).add(platformWarning)
}
```

### 3.2 Component Control

```javascript
exports.control = function(p) {
    p.showPlatform = function(data) {
        const warningPL = p.child('warningCssID')
        
        // Set dynamic content and data
        warningPL.setPostData(data)
        warningPL.setContent('動態警告內容')
        warningPL.show()
    }
    
    p.doPlatform = function(data) {
        // Handle confirmation from modal component
        console.log('Confirmed with data:', data)
    }
}
```

## Modal Configuration Options

### Size Options
- `'small'` - Small modal
- `'medium'` - Default size (can be omitted)
- `'large'` - Large modal  
- `'xlarge'` - Extra large modal

### Common Properties
```javascript
const modalConfig = {
    title: 'Modal Title',          // String or xs element
    body: xs.div(),               // Modal body content
    footer: [button1, button2],   // Array of footer buttons (optional)
    dismiss: true,                // Show X close button (default: true)
    backdrop: 'static',           // 'static' = no close on outside click
    size: 'medium',              // Modal size
    fade: true,                  // Fade animation (default: true)
    vcenter: true,               // Vertical centering (default: true)
    scroll: true                 // Scrollable content (default: true)
}
```

## Modal Control Methods

### Available Methods
```javascript
const modal = p.child('modalCssID')

modal.show()                     // Show modal
modal.hide()                     // Hide modal  
modal.toggle()                   // Toggle visibility
modal.setTitle('New Title')      // Update title
modal.setBody(content)           // Update body content
modal.setBodyPalet(id, url, data, callback)  // Load palet into body
modal.setFooter([buttons])       // Update footer buttons
```

## Event Handling Patterns

### 1. Parent-Child Communication
```javascript
// Child notifies parent
p.notify('showModal', data)

// Parent handles notification
exports.control = function(p) {
    p.showModal = function(data) {
        // Show modal with data
    }
}
```

### 2. Modal Palet Events
```javascript
// In modal activation
modalPL.setBodyPalet('paletID', '/path/to/palet', data, emCtrl => {
    emCtrl.on('finish', () => modalPL.hide())
    emCtrl.on('cancel', () => modalPL.hide())
    emCtrl.on('dataChanged', (data) => {
        // Handle data changes
    })
})
```

### 3. Button Events
```javascript
// Footer button with event
xs.e('button', {
    type: 'button',
    class: 'btn btn-primary'
}, '確定').on('click', 'this.handleConfirm')
```

## Best Practices

### 1. Modal Lifecycle
- Create empty modals in `exports.view`
- Control modal visibility in `exports.control`
- Load content dynamically with `setBodyPalet()` when possible
- Always hide modal after operations complete

### 2. Event Management
- Use `notify()` for parent-child communication
- Register modal palet events in the `setBodyPalet()` callback
- Clean up events when modal closes

### 3. Data Management
- Pass data through `setBodyPalet()` parameters
- Use modal component methods like `setPostData()` for component-based modals
- Refresh parent data after modal operations

### 4. User Experience  
- Use `backdrop: 'static'` for important dialogs
- Provide clear cancel/close options
- Show loading states for async operations
- Provide confirmation for destructive actions

### 5. Performance
- Reuse empty modals rather than creating new ones
- Load palet content only when modal is shown
- Dispose of heavy modal content after use

## Common Patterns Summary

| Pattern | Use Case | Implementation |
|---------|----------|----------------|
| Empty Modal + Palet | Complex, reusable content | `genModal()` + `setBodyPalet()` |
| Static Content | Simple, fixed content | Direct `bs5UIC.create()` with content |
| Component Modal | Reusable modal types | Import component + `.create()` |

This document provides the foundation for implementing consistent, maintainable modal dialogs across wnode applications using Bootstrap 5 and wbs5.