# wnode CheckIn Validation Patterns

## Overview

The wnode framework uses a sophisticated parameter validation system through `exports.checkIn` specifications. This system validates input parameters against defined rules, providing type checking, range validation, and default value assignment.

## CheckIn Object Structure

### Basic Pattern
```javascript
exports.checkIn = {
    parameterName: {
        '@type': 'dataType',          // Required: data type specification
        '@required': true|false,      // Optional: whether parameter is required
        '@default': value|function,   // Optional: default value or function
        '@verifier': function|[functions], // Optional: custom validation functions
        '@errCode': number,           // Optional: custom error code
        '@error': 'message'           // Optional: custom error message
    }
}
```

## Data Type Specifications

### Primitive Types

#### String
```javascript
'@type': 'string'              // Basic string
'@type': 'string(10)'          // Max 10 characters
'@type': 'string[a..z]'        // Range: a to z
'@type': 'string{red,green,blue}' // Enum: red, green, or blue
'@type': 'string(10)[a..z]'    // Combined: max 10 chars, range a-z
```

#### Integer
```javascript
'@type': 'integer'             // Basic integer
'@type': 'integer(5)'          // Max 5 digits
'@type': 'integer[1..100]'     // Range: 1 to 100
'@type': 'integer{1,5,10}'     // Enum: 1, 5, or 10
'@type': 'integer[1<..<100]'   // Exclusive range: 1 < value < 100
```

#### Float
```javascript
'@type': 'float'               // Basic float
'@type': 'float(8,2)'          // Max 8 digits, 2 decimal places
'@type': 'float[0.1..99.9]'    // Range: 0.1 to 99.9
```

#### Boolean
```javascript
'@type': 'bool'                // Boolean: true/false, 1/0, 'true'/'false'
```

#### Date
```javascript
'@type': 'date'                // Basic date validation
'@type': 'date(YYYY-MM-DD)'    // Specific format using moment.js
'@type': 'date[2023-01-01..2023-12-31]' // Date range
```

### Complex Types

#### Arrays
```javascript
'@type': ['string']            // Array of strings
'@type': ['integer{1,2,3}']    // Array of integers (1, 2, or 3)
'@type': [{                    // Array of objects
    name: '@type': 'string',
    age: '@type': 'integer[0..120]'
}]
```

#### Objects
```javascript
'@type': {                     // Nested object validation
    property1: '@type': 'string',
    property2: {
        '@type': 'integer',
        '@required': true
    }
}
```

## Range and Constraint Syntax

### Range Operators
- `[a..b]` - Inclusive range: a ≤ value ≤ b
- `[a<..<b]` - Exclusive range: a < value < b  
- `[a<..b]` - Mixed range: a < value ≤ b
- `[a..<b]` - Mixed range: a ≤ value < b
- `[..b]` - Upper bound only: value ≤ b
- `[a..]` - Lower bound only: value ≥ a

### Enum Syntax
- `{value1,value2,value3}` - Must be one of the listed values

### Size Constraints
- `(n)` - Maximum length/digits for strings/numbers
- `(m,n)` - For floats: m total digits, n decimal places

## Validation Keywords

### @required
```javascript
'@required': true              // Parameter must be provided
'@required': false             // Parameter is optional (default)
```

### @default
```javascript
'@default': 'defaultValue'     // Static default value
'@default': function(value) {  // Dynamic default value
    return computeDefault()
}
```

### @verifier
```javascript
'@verifier': function(paramName, inputObject) {
    return inputObject[paramName] > 0  // Return true if valid
}

'@verifier': [verifier1, verifier2]  // Multiple verifiers (all must pass)
```

### @errCode and @error
```javascript
'@errCode': 1001,              // Custom error code
'@error': 'Custom error message for this parameter'
```

## Real-World Examples

### Basic Component Validation
```javascript
exports.checkIn = {
    forOrder: {
        '@type': 'bool',
        '@default': false,
        '@explain': 'Whether this component is used for order creation'
    },
    invNoList: {
        '@type': []
    }
}
```

### Complex Form Validation
```javascript
exports.checkIn = {
    mode: {
        '@type': 'string{order,invoice}',
        '@required': true
    },
    customerData: {
        '@type': {
            name: {
                '@type': 'string(50)',
                '@required': true
            },
            email: {
                '@type': 'string[^.+@.+\\..+$]',  // Email regex pattern
                '@required': true
            },
            age: {
                '@type': 'integer[18..120]',
                '@default': 18
            }
        }
    },
    products: {
        '@type': [{
            id: {
                '@type': 'integer',
                '@required': true
            },
            quantity: {
                '@type': 'integer[1..999]',
                '@default': 1
            },
            price: {
                '@type': 'float(10,2)[0.01..]',
                '@required': true
            }
        }]
    }
}
```

### Invoice-Specific Example
```javascript
exports.checkIn = {
    invoiceType: {
        '@type': 'string{common,nid,donate,exchange}',
        '@default': 'common'
    },
    carrierType: {
        '@type': 'integer{1,2,3,5,10}',
        '@required': true
    },
    invoiceTime: {
        '@type': 'date(YYYY-MM-DD HH:mm:ss)'
    },
    products: {
        '@type': [],
        '@required': true,
        '@verifier': function(paramName, inputObj) {
            return inputObj[paramName].length > 0  // Must have at least one product
        }
    }
}
```

## Error Handling

The checkIn system returns standardized error objects:

```javascript
// Success
{code: 0, value: validatedData}

// Error
{
    code: 21,  // Error code (see errCode.js)
    message: 'The parameter "age" is not within the range [18..120].'
}
```

### Common Error Codes
- `0` - OK (success)
- `3` - REQUIRED (missing required parameter)
- `10` - NOT_STRING (type mismatch)
- `20` - NOT_INT (type mismatch)
- `22` - INT_RANGE (integer out of range)
- `50` - NOT_ARRAY (expected array)
- `60` - NOT_OBJECT (expected object)

## Best Practices

### 1. Always Define checkIn for Components
```javascript
// Good
exports.checkIn = {
    mode: {'@type': 'string{order,invoice}'},
    config: {'@type': {}}
}

// Bad - Using function pattern
exports.checkIn = function(inData) {
    return {code: 0}
}
```

### 2. Use Meaningful Validation Rules
```javascript
// Good - Specific validation
exports.checkIn = {
    email: {
        '@type': 'string(100)',
        '@required': true
    },
    status: {
        '@type': 'integer{0,1,2}',
        '@default': 0
    }
}

// Bad - Too permissive
exports.checkIn = {
    email: {'@type': 'string'},
    status: {'@type': 'integer'}
}
```

### 3. Provide Sensible Defaults
```javascript
exports.checkIn = {
    pageSize: {
        '@type': 'integer[1..100]',
        '@default': 20
    },
    sortOrder: {
        '@type': 'string{asc,desc}',
        '@default': 'asc'
    }
}
```

### 4. Use Custom Verifiers for Complex Logic
```javascript
exports.checkIn = {
    startDate: {'@type': 'date(YYYY-MM-DD)'},
    endDate: {
        '@type': 'date(YYYY-MM-DD)',
        '@verifier': function(paramName, obj) {
            // End date must be after start date
            return !obj.startDate || obj.endDate >= obj.startDate
        },
        '@error': 'End date must be after start date'
    }
}
```

## Migration from Function Pattern

If you find legacy function-based checkIn:

```javascript
// Legacy (incorrect)
exports.checkIn = function(inData) {
    return {code: 0}
}
```

Convert to object pattern:

```javascript
// Modern (correct)
exports.checkIn = {
    // Define your actual parameter requirements here
}
```

This comprehensive validation system ensures data integrity and provides clear error messaging throughout the wnode application framework.