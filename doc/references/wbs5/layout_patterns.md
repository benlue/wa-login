# WBS5 Layout Patterns Reference

## Overview

The bs5:layout library provides Bootstrap 5 grid system integration for wnode with three main functions for creating responsive layouts.

## Core Functions

### 1. `layout(plan, contents)`

**Purpose**: Recursive layout function for nested structures  
**Parameters**:
- `plan` (Object): Layout plan with `class` and optional `c` properties
- `contents` (Array): Array of content elements

**Pattern**:
```javascript
const plan = {
    class: 'container',
    c: [                    // Child plans (optional)
        { class: 'row' },
        { class: 'col-6' }
    ]
}
const result = bsLayout.layout(plan, [content1, content2, content3])
```

### 2. `grid(plan, contents)` ⭐ **Most Common**

**Purpose**: Generate Bootstrap grid container with rows and columns  
**Parameters**:
- `plan` (Object): Grid plan with `class` and `rows` properties
- `contents` (Array): Array of arrays (rows containing column elements)

**Pattern**:
```javascript
const plan = {
    class: 'container',     // Default: 'container'
    rows: [
        {
            class: 'row',   // Default: 'row'
            cols: ['col-6', 'col-6']  // CSS classes for each column
        },
        {
            class: 'row gx-4',
            cols: ['col-4', 'col-4', 'col-4']
        }
    ]
}

const contents = [
    [element1, element2],           // First row columns
    [element3, element4, element5]  // Second row columns
]

const grid = bsLayout.grid(plan, contents)
```

### 3. `rowGrid(plan, row)`

**Purpose**: Generate single Bootstrap row with columns  
**Parameters**:
- `plan` (Object): Row plan with `class` and `cols` properties
- `row` (Array): Array of column elements

**Pattern**:
```javascript
const plan = {
    class: 'row justify-content-center',  // Default: 'row'
    cols: ['col-lg-4', 'col-lg-6', 'col-lg-2']
}
const row = [leftElement, centerElement, rightElement]
const result = bsLayout.rowGrid(plan, row)
```

## Real-World Examples

### Simple Two-Column Layout
```javascript
const grid = bsLayout.grid({
    class: 'container-fluid',
    rows: [
        { class: 'row', cols: ['col-md-6', 'col-md-6'] }
    ]
}, [
    [leftContent, rightContent]
])
```

### Complex Form Layout
```javascript
const formGrid = bsLayout.grid({
    class: 'container',
    rows: [
        { class: 'row mb-3', cols: ['col-12'] },           // Header row
        { class: 'row mb-3', cols: ['col-6', 'col-6'] },   // Two equal columns
        { class: 'row mb-3', cols: ['col-4', 'col-4', 'col-4'] }, // Three columns
        { class: 'row', cols: ['col-8', 'col-4'] }         // Main + sidebar
    ]
}, [
    [headerElement],
    [nameField, emailField],
    [countrySelect, citySelect, districtSelect],
    [addressField, actionButtons]
])
```

### Responsive Layout with Utilities
```javascript
const responsiveGrid = bsLayout.grid({
    class: 'container text-center',
    rows: [
        {
            class: 'row justify-content-md-center',
            cols: ['col col-lg-2', 'col-md-auto', 'col col-lg-2']
        },
        {
            class: 'row gx-4',
            cols: ['col-6 col-md-4', 'col-6 col-md-4', 'col-6 col-md-4']
        }
    ]
}, [
    [leftSidebar, mainContent, rightSidebar],
    [card1, card2, card3]
])
```

## Key Points

1. **grid() is the most commonly used function** for standard Bootstrap layouts
2. **Contents structure must match rows**: Array of arrays where each inner array contains column elements
3. **CSS classes in cols array map to columns**: `cols[0]` applies to first column, `cols[1]` to second, etc.
4. **If more columns than CSS classes**: Extra columns are rendered without Bootstrap column classes
5. **Row specifications cycle**: If more content rows than row specs, specs repeat from the beginning

## Common Mistakes

❌ **Wrong**: Using arrays for plan parameter
```javascript
// This is INCORRECT
bsLayout.layout([6, 6], [element1, element2])
```

✅ **Correct**: Using object with proper structure
```javascript
bsLayout.grid({
    rows: [{ cols: ['col-6', 'col-6'] }]
}, [[element1, element2]])
```

❌ **Wrong**: Flat contents array for grid
```javascript
// This is INCORRECT
bsLayout.grid(plan, [element1, element2, element3])
```

✅ **Correct**: Nested contents array for grid
```javascript
bsLayout.grid(plan, [[element1, element2], [element3]])
```

## Default Values

- Grid container class: `'container'` if not specified
- Row class: `'row'` if not specified  
- Column classes: Applied only if specified in `cols` array