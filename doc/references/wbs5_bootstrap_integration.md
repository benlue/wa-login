# WBS5 - Bootstrap 5 Integration for wnode

WBS5 (wnode-Bootstrap-5) is a comprehensive abstraction layer that simplifies Bootstrap 5 component creation within the wnode framework. It provides both JavaScript library functions and UIC wrappers.

## Project Structure

```
porting/wbs5/
├── lib/bs5/              # Core JavaScript libraries
│   ├── main.js          # Bootstrap components (alert, accordion, dropdown, etc.)
│   ├── form.js          # Form controls and labels
│   ├── layout.js        # Grid layout system
│   ├── table.js         # Table and pagination
│   └── formatUtil.js    # Data formatting utilities
└── uic/bs5/components/  # wnode UIC wrappers
    ├── accordion.xs     # Accordion UIC
    ├── carousel.xs      # Carousel UIC
    ├── dropdown.xs      # Dropdown UIC
    ├── modal.xs         # Modal UIC
    └── tab.xs          # Tab UIC
```

## wnode Module Resolution

**Important**: wnode provides customized `require()` and `importUIC()` functions that automatically resolve WBS5 module paths. You don't need to worry about the physical file locations - wnode handles the path resolution internally.

- `require('bs5:main')` - wnode automatically finds the bs5 main library
- `require('bs5:form')` - wnode automatically finds the bs5 form library
- `importUIC('bs5:components')` - wnode automatically finds the bs5 UIC components

This means WBS5 libraries are available out-of-the-box without additional setup or configuration.

## Usage Patterns

### 1. Library Functions (Direct Usage)

```javascript
// Import the library - wnode resolves paths automatically
const bs5 = require('bs5:main')
const bsForm = require('bs5:form')

// Create components in exports.view
exports.view = function(model, ctx) {
    return xs.root(css())
        .add(bs5.alert('success', 'Operation completed!'))
        .add(bs5.dropdown(menuItems, {direction: 'dropend'}))
        .add(bsForm.makeControl({
            type: 'email',
            label: 'Email Address',
            required: true
        }))
}
```

### 2. UIC Components (wnode Pattern)

```javascript
// Import UIC group - wnode resolves paths automatically
const bs5UIC = importUIC('bs5:components')

// Use in exports.view
exports.view = function(model, ctx) {
    return xs.root(css())
        .add(
            bs5UIC.create('modal', 'confirmModal', {
                title: 'Confirmation',
                body: 'Are you sure?',
                size: 'large'
            })
        )
}

// Control methods in exports.control
exports.control = function(c, model, ctx) {
    const modal = c.child('confirmModal')
    
    c.startup = function() {
        modal.show() // Show modal
    }
}
```

## Core Components (main.js)

### Basic Components
- `alert(type, message)` - Bootstrap alerts
- `breadCrumb(items, config)` - Navigation breadcrumbs
- `listGroup(items, config)` - List groups
- `navbar(brand, items, config)` - Navigation bars

### Interactive Components
- `accordion(items, config)` - Collapsible accordions
- `carousel(items, config)` - Image/content carousels
- `dropdown(items, config)` - Dropdown menus
- `offCanvas(title, body, config)` - Side panels

### Configuration Examples

```javascript
// Dropdown with extensive configuration
const dropdown = bs5.dropdown([
    {text: 'Action', link: '#action'},
    {text: 'Another action', link: '#another'},
    {divider: true},
    {text: 'Separated link', link: '#separated'}
], {
    direction: 'dropend',    // dropup, dropend, dropstart
    autoClose: 'outside',    // true, false, inside, outside
    theme: 'dark'
})

// Accordion configuration
const accordion = bs5.accordion([
    {title: 'Item 1', body: 'Content 1', collapsed: false},
    {title: 'Item 2', body: 'Content 2', collapsed: true}
], {
    flush: true,
    alwaysOpen: false
})
```

## Form Controls (form.js)

### Main Functions
- `makeControl(spec)` - Complete form control (label + input)
- `makeLabel(spec)` - Form labels with associations
- `makeWidget(spec)` - Individual form inputs
- `makeSelect(items, config)` - Select dropdowns

### Form Control Specification

```javascript
const control = bsForm.makeControl({
    type: 'email',           // text, email, password, number, etc.
    label: 'Email Address',
    name: 'userEmail',
    required: true,
    value: model.email,
    placeholder: 'Enter your email',
    size: 'lg',             // sm, lg
    readonly: false,
    disabled: false,
    format: {type: 'email'}, // Formatting options
    on: {
        change: 'this.emailChanged'
    },
    prop: {                 // Additional HTML attributes
        'data-custom': 'value'
    }
})

// control is an object with: {spec, label, input}
// To use it:
const formGroup = xs.div({class: 'mb-3'})
                    .add(control.label)
                    .add(control.input)
```

### Supported Input Types
- **Standard**: text, email, password, number, tel, url, color, file
- **Special**: textarea, checkbox, radio, switch, range
- **Advanced**: plaintext mode, validation states

## Layout System (layout.js)

### Grid Layout

```javascript
const bsLayout = require('bs5:layout')

// Create responsive grid
const layout = bsLayout.layout([
    [12],              // Full width row
    [6, 6],           // Two equal columns
    [4, 4, 4],        // Three equal columns
    [3, 6, 3]         // Sidebar-content-sidebar
], [
    content1,
    [content2a, content2b],
    [content3a, content3b, content3c],
    [sidebar1, mainContent, sidebar2]
])
```

## Table Components (table.js)

### Data Tables

```javascript
const bsTable = require('bs5:table')

const table = bsTable.create({
    headers: [
        {text: 'Name', align: 'left', width: '30%'},
        {text: 'Email', align: 'left', width: '40%'},
        {text: 'Actions', align: 'center', width: '30%'}
    ],
    rows: [
        ['John Doe', 'john@example.com', 'Edit | Delete'],
        ['Jane Smith', 'jane@example.com', 'Edit | Delete']
    ],
    striped: true,
    hover: true,
    bordered: true
})

// Pagination
const pagination = bsTable.pagination({
    currentPage: 1,
    totalPages: 10,
    maxVisible: 5,
    size: 'lg'
})
```

## UIC Components Control Methods

### Modal UIC Methods
```javascript
const modal = c.child('modalId')
modal.show()                    // Show modal
modal.hide()                    // Hide modal
modal.toggle()                  // Toggle visibility
modal.setTitle('New Title')     // Update title
modal.setBody('New content')    // Update body
modal.config({size: 'xl'})      // Update configuration
```

### Accordion UIC Methods
```javascript
const accordion = c.child('accordionId')
accordion.openItem(0)           // Open first item
accordion.closeItem(1)          // Close second item
accordion.closeAll()            // Close all items
accordion.isItemOpen(0)         // Check if item is open
```

### Dropdown UIC Methods
```javascript
const dropdown = c.child('dropdownId')
dropdown.show()                 // Show dropdown
dropdown.hide()                 // Hide dropdown
dropdown.toggle()               // Toggle visibility
dropdown.getCurrentItem()       // Get selected item
```

### Tab UIC Methods
```javascript
const tabs = c.child('tabsId')
tabs.show(2)                    // Show third tab (0-indexed)
tabs.activeTab()                // Get active tab index
tabs.on('shown', function(idx) { // Event handler
    console.log('Tab', idx, 'shown')
})
```

## Data Formatting (formatUtil.js)

### Format Function

```javascript
const formatUtil = require('bs5:formatUtil')

// Currency formatting
const formatted = formatUtil.format({
    type: 'currency',
    currency: 'USD',
    locale: 'en-US'
}, 1234.56) // Returns "$1,234.56"

// DateTime formatting
const dateFormatted = formatUtil.format({
    type: 'datetime',
    format: 'YYYY-MM-DD HH:mm'
}, new Date()) // Returns formatted date string
```

## Best Practices

### 1. Component Configuration
- Always validate required parameters
- Use meaningful IDs for components
- Leverage Bootstrap's responsive classes
- Configure accessibility attributes

### 2. UIC Integration
- Follow wnode UIC patterns (checkIn, view, control)
- Use proper event handling and notification
- Implement error handling with graceful fallbacks
- Maintain separation between view generation and runtime control

### 3. Form Handling
- Use `makeControl` for complete form fields
- Implement proper validation
- Format data appropriately
- Handle events in the control function

### 4. Layout Planning
- Plan responsive breakpoints
- Use semantic grid structures
- Consider mobile-first design
- Leverage Bootstrap's utility classes

## Integration with wnode

### In exports.view (Server-side)
```javascript
exports.view = function(model, ctx) {
    const bs5 = require('bs5:main')
    const bsForm = require('bs5:form')
    
    return xs.root(css())
        .add(bs5.alert('info', 'Welcome to the system'))
        .add(bsForm.makeControl({
            type: 'text',
            label: 'Username',
            name: 'username'
        }))
}
```

### In exports.control (Client-side)
```javascript
exports.control = function(c, model, ctx) {
    c.startup = function() {
        // Initialize Bootstrap components
        const modal = c.child('myModal')
        if (modal) {
            modal.show()
        }
    }
}
```

This integration provides a seamless bridge between Bootstrap 5's powerful UI components and wnode's component architecture, maintaining type safety, accessibility, and proper event handling throughout.