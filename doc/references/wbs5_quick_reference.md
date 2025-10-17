# WBS5 Quick Reference

Quick reference for Bootstrap 5 integration in wnode projects.

## Import Patterns

```javascript
// Library functions
const bs5 = require('bs5:main')
const bsForm = require('bs5:form')
const bsLayout = require('bs5:layout')
const bsTable = require('bs5:table')

// UIC components
const bs5UIC = importUIC('bs5:components')
```

## Common Components

### Alerts
```javascript
bs5.alert('success', 'Success message')
bs5.alert('danger', 'Error message')
bs5.alert('warning', 'Warning message')
bs5.alert('info', 'Info message')
```

### Buttons (via form controls)
```javascript
bsForm.makeWidget({
    type: 'button',
    text: 'Click Me',
    theme: 'primary',  // primary, secondary, success, danger, warning, info
    size: 'lg',        // sm, lg
    on: {click: 'this.buttonClicked'}
})
```

### Form Controls
```javascript
// Text input - makeControl returns {spec, label, input}
const textControl = bsForm.makeControl({
    type: 'text',
    label: 'Full Name',
    name: 'fullName',
    required: true,
    placeholder: 'Enter your name'
})
// Usage: container.add(textControl.label).add(textControl.input)

// Radio buttons
const radioControl = bsForm.makeControl({
    type: 'radio',
    label: 'Option 1',
    name: 'choice',
    value: 'option1'
})
// Usage: 
const formGroup = xs.div({class: 'form-check'})
                     .add(radioControl.input)
                     .add(radioControl.label)

// Select dropdown
bsForm.makeSelect([
    {value: 'option1', text: 'Option 1'},
    {value: 'option2', text: 'Option 2'}
], {
    label: 'Choose Option',
    name: 'selection'
})

// Checkbox
const checkControl = bsForm.makeControl({
    type: 'checkbox',
    label: 'I agree to terms',
    name: 'agree',
    value: 'yes'
})
```

### Layout Grid
```javascript
bsLayout.layout([
    [12],      // Full width
    [6, 6],    // Two columns
    [4, 8],    // Sidebar + content
    [3, 6, 3]  // Three columns
], [
    headerContent,
    [leftColumn, rightColumn],
    [sidebar, mainContent],
    [leftSide, center, rightSide]
])
```

### Tables
```javascript
bsTable.create({
    headers: [
        {text: 'Name', width: '40%'},
        {text: 'Email', width: '40%'},
        {text: 'Actions', width: '20%', align: 'center'}
    ],
    rows: data.map(item => [
        item.name,
        item.email,
        'Edit | Delete'
    ]),
    striped: true,
    hover: true
})
```

## UIC Components

### Modal
```javascript
// Create modal
bs5UIC.create('modal', 'myModal', {
    title: 'Modal Title',
    body: 'Modal content here',
    size: 'lg',  // sm, lg, xl
    backdrop: true,
    keyboard: true
})

// Control methods (in exports.control)
const modal = c.child('myModal')
modal.show()
modal.hide()
modal.setTitle('New Title')
modal.setBody('New content')
```

### Dropdown
```javascript
// Create dropdown
bs5UIC.create('dropdown', 'myDropdown', {
    text: 'Dropdown Button',
    items: [
        {text: 'Action', value: 'action1'},
        {text: 'Another action', value: 'action2'},
        {divider: true},
        {text: 'Something else', value: 'action3'}
    ],
    direction: 'dropend'  // dropup, dropend, dropstart
})

// Control methods
const dropdown = c.child('myDropdown')
dropdown.show()
dropdown.hide()
const selected = dropdown.getCurrentItem()
```

### Accordion
```javascript
// Create accordion
bs5UIC.create('accordion', 'myAccordion', {
    items: [
        {title: 'Section 1', body: 'Content 1', collapsed: false},
        {title: 'Section 2', body: 'Content 2', collapsed: true}
    ],
    flush: true,
    alwaysOpen: false
})

// Control methods
const accordion = c.child('myAccordion')
accordion.openItem(0)
accordion.closeItem(1)
accordion.closeAll()
```

### Tabs
```javascript
// Create tabs
bs5UIC.create('tab', 'myTabs', {
    items: [
        {title: 'Tab 1', body: 'Content 1', active: true},
        {title: 'Tab 2', body: 'Content 2'},
        {title: 'Tab 3', body: 'Content 3'}
    ],
    vertical: false,
    pills: false
})

// Control methods
const tabs = c.child('myTabs')
tabs.show(1)  // Show second tab
const activeIdx = tabs.activeTab()
```

## Common Configurations

### Sizes
- **Components**: `sm`, `lg`, `xl`
- **Forms**: `sm`, `lg`
- **Buttons**: `sm`, `lg`

### Themes/Colors
- `primary`, `secondary`, `success`, `danger`, `warning`, `info`, `light`, `dark`

### Form Input Types
- `text`, `email`, `password`, `number`, `tel`, `url`
- `textarea`, `checkbox`, `radio`, `switch`, `range`
- `file`, `color`, `date`, `time`, `datetime-local`

### Responsive Breakpoints
- Grid columns: 1-12
- Responsive prefixes: `xs`, `sm`, `md`, `lg`, `xl`, `xxl`

## Event Handling Pattern

```javascript
// In exports.view - register event handler
.on('click', 'this.handleClick')

// In exports.control - implement handler
c.handleClick = function(event) {
    // Handle the click event
    // Access DOM: c.find('#elementId')
    // Notify parent: c.notify('eventName', data)
}
```

## Error Handling

All WBS5 functions include validation:
- Parameter type checking
- Required field validation  
- Graceful fallbacks with error alerts
- Console warnings for development

## Best Practices

1. **Always validate input data before passing to WBS5 functions**
2. **Use meaningful IDs for all components**
3. **Handle errors gracefully in production**
4. **Follow Bootstrap 5 accessibility guidelines**
5. **Test responsive behavior across device sizes**
6. **Use UIC components for complex interactions**
7. **Use library functions for simple component generation**