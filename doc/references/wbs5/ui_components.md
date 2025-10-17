# WBS5 UI Components Reference

Based on source code analysis of `bs5:main` module.

## Alert Components

### `alert(type, message)`

Creates Bootstrap alert component.

**Parameters:**
- `type` (String): Alert type - 'primary', 'secondary', 'success', 'danger', 'warning', 'info', 'light', 'dark'
- `message` (String): Alert message content

**Usage:**
```javascript
const bs5 = require('bs5:main')

const successAlert = bs5.alert('success', 'Operation completed successfully!')
const errorAlert = bs5.alert('danger', 'Something went wrong')
```

## Accordion Components

### `accordion(items, config)`

Creates Bootstrap accordion component.

**Parameters:**
- `items` (Array): Accordion items with `{header, body, show}`
  - `header` (String|Object): Header content
  - `body` (String|Object): Body content
  - `show` (Boolean): Whether item is initially open
- `config` (Object): Configuration options
  - `flush` (Boolean): Remove borders (accordion-flush)
  - `alwaysOpen` (Boolean): Allow multiple items open

**Usage:**
```javascript
const accordion = bs5.accordion([
    {header: 'Section 1', body: 'Content 1', show: true},
    {header: 'Section 2', body: 'Content 2', show: false}
], {
    flush: true,
    alwaysOpen: false
})
```

## Breadcrumb Components

### `breadCrumb(items, config)`

Creates Bootstrap breadcrumb navigation.

**Parameters:**
- `items` (Array): Breadcrumb items (strings or objects)
  - String: Simple text
  - Object: `{value, link}` with optional link
- `config` (Object): Configuration options
  - `divider` (String): Custom divider character

**Usage:**
```javascript
const breadcrumb = bs5.breadCrumb([
    {value: 'Home', link: '/'},
    {value: 'Products', link: '/products'},
    'Current Page'
], {
    divider: '>'
})
```

## Carousel Components

### `carousel(items, config)`

Creates Bootstrap carousel component.

**Parameters:**
- `items` (Array): Slide objects
  - `element` (Object): Slide content (JSONH element)
  - `caption` (Object): Optional slide caption
  - `interval` (Number): Time between slides
- `config` (Object): Configuration options
  - `id` (String): Custom carousel ID
  - `indicators` (Boolean): Show slide indicators
  - `prevNext` (Boolean): Show prev/next buttons
  - `fade` (Boolean): Enable fade transition
  - `ride` (String): Auto-ride behavior
  - `touch` (Boolean): Enable touch swipe

**Usage:**
```javascript
const carousel = bs5.carousel([
    {element: xs.e('img', {src: 'slide1.jpg'})},
    {element: xs.e('img', {src: 'slide2.jpg'})}
], {
    indicators: true,
    prevNext: true,
    fade: false
})
```

## Dropdown Components

### `dropdown(items, config)`

Creates Bootstrap dropdown menu.

**Parameters:**
- `items` (Array): Menu items or elements
  - Object: `{label, value, link, class, active, disabled}`
  - Element: Custom JSONH element
- `config` (Object): Configuration options
  - `label` (String): Dropdown button text
  - `tag` (String): Button tag ('button' or 'a')
  - `horizontal` (Boolean): Horizontal menu layout
  - `btnClass` (String): Button CSS classes
  - `btnStyle` (String): Button inline styles
  - `splitBtn` (Boolean): Split button style
  - `direction` (String): Menu direction ('center', 'dropup', 'dropend', 'dropstart', 'dropup-center')
  - `menuClass` (String): Menu CSS classes
  - `autoClose` (String): Auto-close behavior ('true', 'false', 'inside', 'outside')

**Usage:**
```javascript
const dropdown = bs5.dropdown([
    {label: 'Action', value: 'action1'},
    {label: 'Another action', value: 'action2'},
    {divider: true},
    {label: 'Disabled', value: 'disabled', disabled: true}
], {
    label: 'Dropdown Menu',
    btnClass: 'btn-primary',
    direction: 'dropend',
    autoClose: 'outside'
})
```

## List Components

### `listGroup(items, config)`

Creates Bootstrap list group.

**Parameters:**
- `items` (Array): List items (elements created with `listItem()`)
- `config` (Object): Configuration options
  - `tag` (String): Container tag ('ul' or 'div')
  - `flush` (Boolean): Remove borders
  - `numbered` (Boolean): Numbered list
  - `class` (String): Additional CSS classes

### `listItem(item)`

Creates individual list item.

**Parameters:**
- `item` (String|Object): Item content or configuration
  - String: Simple text content
  - Object: `{value, tag, class, active, disabled, action, link}`

**Usage:**
```javascript
const items = [
    bs5.listItem('Simple item'),
    bs5.listItem({value: 'Active item', active: true}),
    bs5.listItem({value: 'Link item', tag: 'a', link: '#'})
]

const listGroup = bs5.listGroup(items, {
    flush: true,
    numbered: false
})
```

## Navbar Components

### `navbar(brand, items, config)`

Creates Bootstrap navbar.

**Parameters:**
- `brand` (Object): Brand element (use `navbarBrand()`)
- `items` (Array): Menu items (use `navbarItem()`)
- `config` (Object): Configuration options
  - `id` (String): Navbar ID
  - `class` (String): Additional CSS classes
  - `darkTheme` (Boolean): Dark theme
  - `toggleRight` (Boolean): Right-aligned toggle

### `navbarBrand(brand, link)`

Creates navbar brand element.

### `navbarItem(item)`

Creates navbar menu item.

**Usage:**
```javascript
const brand = bs5.navbarBrand('My App', '/')
const items = [
    bs5.navbarItem({value: 'Home', link: '/', active: true}),
    bs5.navbarItem({value: 'About', link: '/about'})
]

const navbar = bs5.navbar(brand, items, {
    darkTheme: true,
    class: 'navbar-expand-lg'
})
```

## Off-Canvas Components

### `offCanvas(title, body, config)`

Creates Bootstrap off-canvas component.

**Parameters:**
- `title` (String): Off-canvas title
- `body` (String|Object): Off-canvas content
- `config` (Object): Configuration options
  - `id` (String): Custom ID
  - `classes` (String): Additional CSS classes
  - `placement` (String): Position ('start', 'end', 'top', 'bottom')
  - `backdrop` (String): Backdrop behavior ('true', 'false', 'static')
  - `scroll` (Boolean): Allow body scrolling
  - `show` (Boolean): Initially visible

**Usage:**
```javascript
const offCanvas = bs5.offCanvas('Menu', menuContent, {
    placement: 'start',
    backdrop: 'true',
    scroll: false
})
```

## Utility Functions

### `getIDCount()`

Returns auto-incrementing ID for unique component identification.

## Error Handling

All components include:
- Parameter type validation
- Required field checking
- Descriptive error messages
- Graceful fallbacks

## Best Practices

1. **Use semantic component types** for better accessibility
2. **Provide meaningful IDs** for interactive components
3. **Test responsive behavior** across device sizes
4. **Handle component events** in exports.control
5. **Use proper Bootstrap themes** and classes
6. **Validate input parameters** before component creation