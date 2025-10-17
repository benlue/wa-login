# Modal UIC Component

Bootstrap 5 Modal UIC component for creating dialog windows in wnode applications.

## Basic Usage

```javascript
const bs5UIC = importUIC('bs5:components')

// In exports.view
const modal = bs5UIC.create('modal', 'myModal', {
    title: 'Modal Title',
    body: 'Modal content goes here',
    footer: [
        xs.e('button', {class: 'btn btn-secondary', 'data-bs-dismiss': 'modal'}, 'Close'),
        xs.e('button', {class: 'btn btn-primary'}, 'Save')
    ],
    size: 'large'
})
```

## Parameters

### Required Parameters

#### `title` (String|Element)
Modal header title. Can be plain text or HTML element.
- **Default**: `'Title'`

#### `body` (String|Element)
Modal body content. Can be text, HTML elements, or embedded palets.
- **Default**: `xs.e('p', '&nbsp')`

### Optional Parameters

#### `id` (String)
CSS ID for the modal. Auto-generated if not provided.

#### `footer` (Array)
Array of footer elements (typically buttons).
```javascript
footer: [
    xs.e('button', {class: 'btn btn-secondary', 'data-bs-dismiss': 'modal'}, 'Cancel'),
    xs.e('button', {class: 'btn btn-primary'}, 'Save')
]
```

#### `dismiss` (Boolean)
Whether to show the close (X) button in header.
- **Default**: `true`

#### `size` (String)
Modal size. Options:
- `'small'` - Small modal
- `'medium'` - Default size (omit parameter)
- `'large'` - Large modal
- `'xlarge'` - Extra large modal

#### `fullscreen` (Boolean)
Whether to make modal fullscreen.
- **Default**: `false`
- **Note**: When combined with `size`, creates responsive fullscreen (e.g., fullscreen on smaller screens)

#### `backdrop` (String)
Backdrop behavior. Options:
- `undefined` - Default clickable backdrop
- `'static'` - Non-dismissible backdrop

#### `fade` (Boolean)
Enable fade animation when showing/hiding.
- **Default**: `true`

#### `scroll` (Boolean)
Make modal body scrollable.
- **Default**: `true`

#### `vcenter` (Boolean)
Vertically center the modal.
- **Default**: `true`

## Control Methods

### Display Methods

#### `show()`
Display the modal
```javascript
const modal = c.child('myModal')
modal.show()
```

#### `hide()`
Hide the modal
```javascript
modal.hide()
```

#### `toggle()`
Toggle modal visibility
```javascript
modal.toggle()
```

### Content Methods

#### `setTitle(title)`
Update modal title
```javascript
modal.setTitle('New Title')
```

#### `setBody(content)`
Update modal body content
```javascript
modal.setBody('New content')
modal.setBody(xs.div('HTML content'))
```

#### `setBodyPalet(id, url, args, callback)`
Embed a palet in modal body
```javascript
modal.setBodyPalet('paletId', 'path/to/palet.xs', {param: 'value'}, function() {
    console.log('Palet loaded')
})
```

#### `setFooter(footer)`
Update modal footer
```javascript
modal.setFooter([
    xs.e('button', {class: 'btn btn-primary'}, 'Updated Button')
])
```

### Configuration Methods

#### `config(options)`
Reconfigure modal with Bootstrap options
```javascript
modal.config({
    backdrop: 'static',
    keyboard: false
})
```

### Event Methods

#### `on(eventName, handler)`
Register event handler
```javascript
modal.on('shown.bs.modal', function() {
    console.log('Modal shown')
})
```

#### `onFooter(cssID, eventName, handler)`
Register event handler on footer button
```javascript
modal.onFooter('saveBtn', 'click', function() {
    console.log('Save button clicked')
})
```

### Property Methods

#### `setProp(key, value)`
Set custom property
```javascript
modal.setProp('userData', {id: 123})
```

#### `getProp(key)`
Get custom property
```javascript
const userData = modal.getProp('userData')
```

## Real-World Examples

### Basic Confirmation Dialog
```javascript
exports.view = function(model, ctx) {
    const bs5UIC = importUIC('bs5:components')

    return xs.root('div')
        .add(
            bs5UIC.create('modal', 'confirmModal', {
                title: 'Confirm Action',
                body: 'Are you sure you want to proceed?',
                footer: [
                    xs.e('button', {
                        class: 'btn btn-secondary',
                        'data-bs-dismiss': 'modal'
                    }, 'Cancel'),
                    xs.e('button', {
                        class: 'btn btn-danger',
                        id: 'confirmBtn'
                    }, 'Confirm').on('click', 'this.confirmAction')
                ],
                size: 'medium'
            })
        )
}

exports.control = function(c, model, ctx) {
    c.confirmAction = function() {
        // Perform action
        const modal = c.child('confirmModal')
        modal.hide()
        c.notify('actionConfirmed')
    }
}
```

### Form Modal with Embedded Palet
```javascript
const formModal = bs5UIC.create('modal', 'formModal', {
    title: 'Edit User',
    body: xs.div({id: 'formContainer'}),
    footer: [
        xs.e('button', {class: 'btn btn-secondary', 'data-bs-dismiss': 'modal'}, 'Cancel'),
        xs.e('button', {class: 'btn btn-primary', id: 'saveUser'}, 'Save')
    ],
    size: 'large',
    backdrop: 'static'
})

// In control
c.showEditUser = function(userId) {
    const modal = c.child('formModal')
    const userFormXS = require('./userForm.xs')

    modal.setTitle('Edit User #' + userId)
    modal.setBody(userFormXS.create('userForm', {userId: userId}))
    modal.show()
}
```

### Dynamic Content Modal
```javascript
exports.control = function(c, model, ctx) {
    const modal = c.child('dynamicModal')

    c.showUserDetails = function(userData) {
        modal.setTitle('User: ' + userData.name)
        modal.setBody(
            xs.div()
                .add(xs.e('h6', 'Email: ' + userData.email))
                .add(xs.e('h6', 'Role: ' + userData.role))
                .add(xs.e('p', userData.bio))
        )
        modal.show()
    }

    c.showErrorMessage = function(error) {
        modal.setTitle('Error')
        modal.setBody(
            xs.div({class: 'alert alert-danger'}, error.message)
        )
        modal.setFooter([
            xs.e('button', {class: 'btn btn-danger', 'data-bs-dismiss': 'modal'}, 'Close')
        ])
        modal.show()
    }
}
```

### Fullscreen Modal for Mobile
```javascript
const mobileModal = bs5UIC.create('modal', 'mobileModal', {
    title: 'Mobile View',
    body: contentElement,
    fullscreen: true,
    size: 'large', // Fullscreen on lg and below
    backdrop: 'static'
})
```

### Modal with Custom Events
```javascript
exports.control = function(c, model, ctx) {
    const modal = c.child('eventModal')

    c.startup = function() {
        // Register modal events
        modal.on('show.bs.modal', function() {
            console.log('Modal is about to show')
            c.prepareModalData()
        })

        modal.on('shown.bs.modal', function() {
            console.log('Modal is fully shown')
            c.focusFirstInput()
        })

        modal.on('hide.bs.modal', function() {
            console.log('Modal is about to hide')
            c.validateAndSave()
        })

        modal.on('hidden.bs.modal', function() {
            console.log('Modal is fully hidden')
            c.cleanupModalData()
        })
    }

    c.prepareModalData = function() {
        // Prepare data before modal shows
    }

    c.focusFirstInput = function() {
        modal.find('input:first').focus()
    }
}
```

## Bootstrap Modal Events

The Modal UIC supports all Bootstrap modal events:

- `show.bs.modal` - Fired immediately when show() is called
- `shown.bs.modal` - Fired when modal is fully shown
- `hide.bs.modal` - Fired immediately when hide() is called
- `hidden.bs.modal` - Fired when modal is fully hidden
- `hidePrevented.bs.modal` - Fired when backdrop click is prevented

## Best Practices

1. **Use meaningful IDs**: Provide clear, unique IDs for modals
2. **Handle events properly**: Register event handlers for modal lifecycle
3. **Manage focus**: Set focus appropriately when modal shows
4. **Validate before closing**: Check form data before allowing modal to close
5. **Clean up resources**: Use `destroy()` method when removing modals
6. **Use appropriate sizes**: Choose size based on content and screen size
7. **Consider accessibility**: Provide proper ARIA labels and keyboard navigation

## Accessibility Features

- Automatic ARIA labeling with modal title
- Keyboard navigation support (ESC to close)
- Focus management
- Screen reader compatibility
- Proper tabindex handling

## Error Handling

The Modal UIC includes built-in error handling:
- Parameter validation through `checkIn`
- Graceful fallbacks for missing content
- Automatic cleanup on destroy