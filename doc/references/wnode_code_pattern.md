# wnode Coding Patterns Reference

This project uses **wnode**, an in-house web server framework. DO NOT suggest React/Vue patterns.

## Core Architecture Overview

wnode uses a **hybrid server-client architecture**:
- **Server-side**: `exports.checkIn`, `exports.model`, `exports.view` 
- **Client-side**: `exports.control` (despite being defined in .xs file)

## Core Palet Structure (4 exports):

### 1. `checkIn` - Parameter validation with `@` prefixed properties
```javascript
exports.checkIn = {
    userId: { '@type': 'integer', '@required': true, '@explain': 'User ID' },
    filter: { '@type': 'string', '@required': false, '@default': 'active', '@explain': 'Filter criteria' }
}
```

**Important**: Use OBJECT-based validation, NOT function-based:
```javascript
// CORRECT - Object pattern
exports.checkIn = {
    param: { '@type': 'dataType', '@explain': 'Description' }
}

// WRONG - Function pattern (legacy)
exports.checkIn = function(inData) { /* validation logic */ }
```

### 2. `model(inData, ctx, cb)` - Server-side data preparation
- **Runs server-side only**
- Prepares data for client-side consumption
- Callback format: `{code: 0, value: data}` or `{code: non-zero, message: "error"}`
- If omitted, `inData` is passed directly to `view` and `control`

### 3. `view(model, ctx)` - Server-side HTML generation
- **Runs server-side only**
- Generates HTML structure using `xs` module
- **Available xs functions**: Only `xs.root()`, `xs.div()`, and `xs.e()`
  - `xs.root()` - Root element (use only once per palet)
  - `xs.div()` - Create div elements
  - `xs.e(tagName, attributes, content)` - Create any HTML element
- Chain methods: `.add()`, `.addText()`, `.on()`, `.attr()`, `.addClass()`
- Event handlers as strings: `.on('click', 'this.handlerName')`
- Include client-side JavaScript files here if needed

**Important**: Do NOT use `xs.h1()`, `xs.span()`, `xs.button()`, etc. - these don't exist! Use `xs.e('h1')`, `xs.e('span')`, `xs.e('button')` instead.

### 4. `control(controller, model, ctx)` - Client-side interaction logic
- **Runs client-side in browser** (despite being defined in .xs file)
- Receives model data from server automatically
- Contains all DOM manipulation, event handling, and interactive logic
- Available methods: `startup()`, `destroy()`, `find()`, `notify()`, `reload()`, `embed()`
- `find()` returns jQuery object for DOM manipulation

## Server-Client Data Flow

```javascript
// Server side (exports.model)
exports.model = function(inData, ctx, cb) {
    cb({ code: 0, value: { config: {...}, data: [...] }})
}

// Client side (exports.control) - automatically receives model data
exports.control = function(p, model, ctx) {
    const { config, data } = model  // Data from server
    
    p.startup = function() {
        // Client-side initialization with server data
    }
}
```

## File Organization Pattern

### Client-Side JavaScript Location
- **All client-side utilities**: `/assets/js/` directory
- **Global inclusion**: Add to layout file (`themes/default/layout/default.xs`)
- **Examples**: Data models, services, utilities that run in browser

### Server-Side Code Location  
- **Palets**: `/themes/default/palets/` - HTML generation and server logic
- **Libraries**: `/lib/` - Shared server-side utilities

```javascript
// In layout/default.xs - include client-side files globally
exports.include = [
    // ... other includes
    '/js/models/DataModel.js',      // Available in all palets
    '/js/services/ApiService.js'    // Available in all palets
]

// In any palet's exports.control - use client-side components
exports.control = function(p, model) {
    let dataModel = new DataModel()  // Globally available
    let apiService = new ApiService() // Globally available
}
```

**Important**: 
- Do NOT include `<script>` tags in individual palet views
- Add client-side utilities to the layout file's `exports.include` array
- All JavaScript files in `exports.include` are automatically available in all palets

## Component Creation Pattern

```javascript
// CORRECT for EZC
const componentInstance = componentXS.create('componentCssID', params)

// NOT this generic pattern  
const componentInstance = xs.create(componentXS, 'componentCssID', params)
```

## Event Communication Pattern

wnode uses **one-way event communication**:

### Child → Parent Communication
- Use `notify()` method to send events up the hierarchy
- Events bubble up through palet hierarchy
- Parents listen to child events and respond accordingly

```javascript
// Child palet notifies parent
p.notify('updateAmount', { total: 1000, tax: 50 })

// Parent palet handles child events (automatically)
p.onUpdateAmount = function(amountData) {
    // Handle the event from child
}
```

### Parent → Child Communication  
- Parents call child controller functions directly
- No event system needed for downward communication

```javascript
// Parent calls child functions directly
const childController = p.child('childCssID')
childController.setData(newData)
childController.refresh()
```

### Client → Server Communication
- Use API calls (one-way only)
- Server cannot directly communicate back (except via SSE, but not common)

```javascript
// Client-side API call
$.post('/webAPI/path/action.wsj', data, response => {
    if (response.code === 0) {
        // Handle success
    }
})
```

Event registration in view:
```javascript
// In exports.view - register event handler as string
componentXS.create('id', params).on('eventName', 'this.handlerFunctionName')

// In exports.control - define handler function
p.handlerFunctionName = function(param1, param2) {
    // Handle locally and/or notify parent
    p.notify('eventName', param1, param2)
}
```

## UIC (UI Components) Pattern

```javascript
// Import as groups (directories)
const uicGroup = importUIC('/path/to/directory')

// Create specific component from group
const component = uicGroup.create('componentName', 'cssID', params, callback)

// Example
const loginUIC = importUIC('/common/login')
const loginCard = loginUIC.create('basic', 'loginCard', loginParams)
```

Key differences from palets:
- No `model` function (or it won't be called)
- Higher reusability across contexts
- Import as directory groups

## API Communication Pattern

```javascript
const api = new coimAPI(ctx)
api.request('/namespace/component/action/[id]', params, function(result) {
    if (result.code === 0) {
        // Success - use result.value
    } else {
        // Error - handle result.message
    }
})
```

Response structure:
- `code`: 0 = success, non-zero = error
- `message`: Error description when code is non-zero
- `value`: Response data when code is 0

## Styling Pattern

```javascript
// Use css() function with xs.root()
xs.root('div', css())

// CSS function can accept parameters
function css(defaultBg, defaultPadding) {
    return {
        backgroundColor: defaultBg,
        padding: defaultPadding
    }
}
```

- CSS rules automatically prefixed with palet path for encapsulation
- Prefer class selectors over ID selectors
- ID selectors are not encapsulated due to CSS spec limitations

## Project Structure

- `assets/`: Static files (CSS, JS, images)
- `lib/`: Shared libraries imported by palets
- `themes/default/palets/`: HTML fragments (building blocks, not directly accessible)
- `themes/default/pages/`: Web pages accessible via URL
- `uic/`: Reusable UI components
- `xs.js`: Client-side library automatically loaded by wnode

## Important Architectural Concepts

### Palet Embedding vs Delegation

**CORRECT - Embedding Pattern**:
```javascript
// In exports.view - embed child palet directly
exports.view = function(model) {
    return xs.root()
             .add(childPaletXS.create('childCssID', params))
}
```

**WRONG - Delegation Pattern**:
```javascript
// DON'T do this - delegation doesn't work in wnode
exports.view = function(model) {
    return delegateToAnotherPalet(params)
}
```

### Accessing Input Parameters

You can access original input parameters in multiple ways:

```javascript
exports.control = function(p, model, ctx) {
    // Method 1: From context (original input)
    const originalParams = p.getContext().query
    
    // Method 2: From model (processed by exports.model)
    const processedData = model
    
    // Method 3: If you passed original in model
    const originalPassthrough = model.query  // if you set it in exports.model
}
```

### Configuration-Driven Architecture

For complex components, prefer configuration over code:

```javascript
// Good - configuration-driven
const config = {
    mode: 'order',           // Simple mode selection
    features: {              // Feature flags
        remarks: true,
        totalDisplay: true
    }
}

// Avoid - parameter explosion  
const params = {
    pdRemarks: true, mixTax: false, invType: 7, isOverseas: 1,
    isCustom: 0, currency: true, compareKeys: [...], memo: "",
    remarks: 2, totalAmount: 1, needConfirmBtn: 1, confirmBtnTxt: "開立"
    // ... 20+ more parameters
}
```

## WBS5 Integration Pattern

### Proper Server-Client Separation for WBS5 Components

**CRITICAL**: WBS5 modules (`bs5:main`, `bs5:form`) are for server-side HTML generation only. Do NOT use them in `exports.control`.

**CORRECT Pattern - Generate server-side, control client-side**:

```javascript
// Server-side (exports.view) - Generate WBS5 components
exports.view = function(model, ctx) {
    const bs5 = require('bs5:main')
    const bsForm = require('bs5:form')

    // Generate alert structure with initial hidden state
    const errorAlert = xs.div({id: 'errorMessage', class: 'd-none'})
                         .add(bs5.alert('danger', 'Error placeholder'))

    // Generate success alert
    const successAlert = xs.div({id: 'successMessage', class: 'd-none'})
                           .add(bs5.alert('success', 'Success placeholder'))

    return xs.root('div')
        .add(/* your content */)
        .add(errorAlert)
        .add(successAlert)
}

// Client-side (exports.control) - Control visibility and content
exports.control = function(p, model, ctx) {
    p.showError = function(message) {
        p.find('#errorMessage .alert').text(message)
        p.find('#errorMessage').removeClass('d-none')
    }

    p.showSuccess = function(message) {
        p.find('#successMessage .alert').text(message)
        p.find('#successMessage').removeClass('d-none')
    }

    p.hideAlerts = function() {
        p.find('#errorMessage, #successMessage').addClass('d-none')
    }
}
```

**WRONG Pattern - Trying to generate WBS5 in client-side**:

```javascript
// DON'T DO THIS - WBS5 in exports.control
exports.control = function(p, model, ctx) {
    p.showError = function(message) {
        const bs5 = require('bs5:main')  // ❌ Wrong - client-side
        const alert = bs5.alert('danger', message)  // ❌ Wrong - HTML generation in browser
        p.find('#container').append(alert)
    }
}
```

## Controller Built-in Functions

Available on the `controller` object in `exports.control`:

- `startup()`: Initialize when palet loads (define as `p.startup = function() {}`)
- `destroy()`: Cleanup when palet is removed
- `child(cssID)`: Get child palet's controller for direct communication
- `find(selector)`: Find DOM elements (returns jQuery object)
- `on(event, handler)`: Register event handler
- `notify(eventName, ...args)`: Send events to parent palets
- `reload(params, callback)`: Refresh palet with new parameters
- `embed(anchor_selector, paletPath, params, callback)`: Embed child palet dynamically
- `getContext()`: Get original context including `query` (input parameters)