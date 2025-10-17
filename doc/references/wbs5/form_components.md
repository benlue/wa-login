# WBS5 Form Components Reference

Based on source code analysis of `bs5:form` module.

## Core Functions

### `makeControl(spec)`

Creates a complete form control with label and input. Returns object with `{spec, label, input}`.

**Spec Properties:**
- `id` (String): CSS ID, auto-generated if not provided
- `name` (String): Form control name
- `value` (String): Initial value
- `type` (String): Input type (see supported types below)
- `label` (String): Label text
- `labelClass` (String): Additional CSS classes for label
- `horizontal` (Boolean): Horizontal form layout
- `prop` (Object): Additional HTML attributes
- `plainText` (Boolean): Style as plaintext input
- `required` (Boolean): Required field
- `readonly` (Boolean): Read-only field
- `disabled` (Boolean): Disabled field
- `checked` (Boolean): For checkbox/radio/switch
- `button` (Boolean): For checkbox - display as toggle button
- `placeholder` (String): Placeholder text
- `format` (Object): Value formatting options
- `on` (Object): Event handlers with `{event: 'eventName', handler: 'this.handlerName'}`

**Usage:**
```javascript
const bsForm = require('bs5:form')

const control = bsForm.makeControl({
    type: 'email',
    label: 'Email Address',
    name: 'email',
    required: true,
    placeholder: 'Enter your email',
    prop: {
        'autocomplete': 'email'
    }
})

// Use in view
xs.div({class: 'mb-3'})
    .add(control.label)
    .add(control.input)
```

### `makeLabel(spec)`

Creates form label element. Returns object with `{id, label}`.

**Spec Properties:**
- `id` (String): Target input ID, auto-generated if not provided
- `label` (String): Label text
- `labelClass` (String): Additional CSS classes
- `horizontal` (Boolean): Horizontal form layout
- `type` (String): Input type (affects label class)

**CSS Classes Applied:**
- Default: `form-label`
- Horizontal: `col-form-label`
- Checkbox/Radio/Switch: `form-check-label`

### `makeWidget(spec)`

Creates form input widget only (no label).

**Spec Properties:** Same as `makeControl()` but focuses on input element only.

**Usage:**
```javascript
const button = bsForm.makeWidget({
    type: 'button',
    prop: {
        class: 'btn btn-primary btn-lg',
        type: 'submit'
    },
    on: {
        event: 'click',
        handler: 'this.handleSubmit'
    }
}).addText('Submit')
```

### `makeSelect(items, config)`

Creates Bootstrap select dropdown.

**Parameters:**
- `items` (Array): Option objects with `{label, value, selected}`
- `config` (Object): Configuration with `{class, prop}`

**Usage:**
```javascript
const select = bsForm.makeSelect([
    {label: 'Option 1', value: '1'},
    {label: 'Option 2', value: '2', selected: true}
], {
    class: 'form-select-lg',
    prop: {
        name: 'choice'
    }
})
```

## Supported Input Types

### Standard Types
- `text` - Text input
- `email` - Email input
- `password` - Password input
- `number` - Number input
- `tel` - Telephone input
- `url` - URL input
- `color` - Color picker
- `file` - File upload

### Special Types
- `textarea` - Multi-line text area
- `checkbox` - Checkbox input
- `radio` - Radio button
- `switch` - Toggle switch
- `range` - Range slider
- `button` - Button element

## Form Control Classes

The module automatically applies appropriate Bootstrap classes:

- **Standard inputs**: `form-control`
- **Plain text**: `form-control-plaintext`
- **Color inputs**: `form-control form-control-color`
- **Checkboxes/Radio**: `form-check-input`
- **Switch**: `form-check-input` with `role="switch"`
- **Button checkboxes**: `btn-check`
- **Range**: `form-range`

## Advanced Features

### Value Formatting
```javascript
const control = bsForm.makeControl({
    type: 'text',
    value: rawValue,
    format: {
        type: 'currency',
        currency: 'USD'
    }
})
```

### Accessibility Features
- Automatic `aria-label` for readonly/disabled inputs
- Proper `for` attribute linking labels to inputs
- Auto-generated IDs when not provided

### Event Handling
```javascript
const control = bsForm.makeControl({
    type: 'text',
    on: {
        event: 'change',
        handler: 'this.fieldChanged'
    }
})
```

## Error Handling

All functions include validation:
- Parameter type checking
- Required field validation
- Throws descriptive errors for invalid configurations

## Best Practices

1. **Always use `makeControl()` for complete form fields** (label + input)
2. **Use `makeWidget()` for standalone inputs** (buttons, custom layouts)
3. **Provide meaningful IDs** for form controls
4. **Use proper input types** for better UX and validation
5. **Include accessibility attributes** in `prop` object
6. **Handle events in exports.control** function