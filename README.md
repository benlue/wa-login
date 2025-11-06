# wa-login

This project demonstrates how to protect your webapp by requiring visitors to sign in before accessing protected content. It showcases several techniques to properly protect a webapp using one specific approach. However, wnode supports various protection schemes—read through this article to understand the flexibility wnode provides.

## What is wnode?

wnode is a web application framework that uses a component-based architecture with server-side HTML generation and client-side interaction control. It emphasizes code reusability through "palets" (reusable HTML fragments) and provides a clean separation between view logic and control logic.

## Webapp Protection Scheme

This app demonstrates wnode's elegant two-layer authorization system that combines **automatic protection** with **fine-grained control**.

### How It Works

#### **1. User Authentication Flow**

1. **Login**: User submits credentials via `/login` page
2. **Password Hashing**: Client hashes password using `SHA256(accName + SHA256(password))` before transmission
3. **Validation**: `backend/authorize.xs` verifies the password hash against stored credentials
4. **Verification Hints Stored In Cookies**: Client saves both `authKey` and `accName` cookies (7-day expiration, SameSite=Strict)

#### **2. Automatic Page Protection**

For every subsequent page request, wnode automatically:

1. **Checks Protection Status**: Looks up the requested path in `themes/default/siteURI.json`
   - If path is listed → uses the `"protected"` property value
   - If path is NOT listed → uses webapp default protection mode

2. **Validates Authorization**: If page requires protection:
   - Reads ALL cookies from the HTTP request
   - Calls `themes/authModule.js#isAuthorized(cookies)`
   - Passes entire cookie object (not just one cookie)
   - `authModule` regenerates expected authKey from `cookies.accName` by `SHA256(accName + FIXED_SECRET)` and compares with `cookies.authKey`
   - Returns `true` if authKey is valid, `false` otherwise

3. **Grants/Denies Access**: Based on validation result

#### **3. Configuration Example**

**File**: `themes/default/siteURI.json`

```json
{
    "/login": {
        "protected": false    // Public - anyone can access
    },
    "/main": {
        "protected": true     // Protected - requires valid authKey
    },
    "/backend/authorize": {
        "protected": false    // Public - needed for login to work
    }
    // Pages not listed here use the webapp's default protection mode
}
```

### Clean and Flexible Protection Scheme

Unlike most web frameworks that require manual protection per route, wnode offers:

#### ✅ **Secure by Default**
- Set your webapp to protected-by-default mode
- Explicitly mark public pages in `siteURI.json`
- Avoid accidentally exposing a protected page
- No decorators to forget, no middleware to miss

#### ✅ **Single Source of Truth**
```json
// One file shows ALL your app's security posture
{
    "/login": {"protected": false},
    "/signup": {"protected": false},
    "/dashboard": {"protected": true},
    "/admin": {"protected": true}
}
```

Compare to Express.js (scattered across files):
```javascript
app.get('/login', handler)           // public - but not obvious!
app.get('/signup', handler)          // public - also not obvious!
app.get('/dashboard', auth, handler) // protected - middleware added
app.get('/admin', auth, handler)     // protected - middleware added
// No single place to see the full picture
```

#### ✅ **Cookie Flexibility**
wnode passes the **entire cookie object** to your validation function:

```javascript
// You decide which cookies to check
exports.isAuthorized = function(cookies) {
    // Use authKey + accName (like we do)
    // Regenerate authKey from accName and verify it matches
    if (cookies.authKey && cookies.accName) {
        const expectedKey = SHA256(cookies.accName + SECRET)
        return cookies.authKey === expectedKey
    }

    // Or use sessionId
    if (cookies.sessionId) return validateSession(cookies.sessionId)

    // Or check multiple cookies
    if (cookies.jwt && cookies.csrf) return validateBoth(cookies)

    // Complete flexibility!
}
```

No framework lock-in. No prescribed authentication library. Your choice.

#### ✅ **Both Automatic AND Granular**
- **Automatic**: All pages check authorization (can't forget)
- **Granular**: Per-page control in siteURI.json
- **Visual**: See entire security model at a glance
- **Safe**: Protected-by-default prevents accidents

### Key Files
Key files regarding webapp protection in this example app:

- **[themes/default/siteURI.json](themes/default/siteURI.json)** - Page-level protection configuration
- **[themes/authModule.js](themes/authModule.js)** - Authorization validation logic
- **[pages/login.xs](themes/default/pages/login.xs)** - Login form with credential submission
- **[palets/backend/authorize.xs](themes/default/palets/backend/authorize.xs)** - Credential verification and authKey generation
- **[pages/main.xs](themes/default/pages/main.xs)** - Protected welcome page

### Test Credentials

```
Username: admin  | Password: admin123
Username: user   | Password: user123
```

### Security Implementation Details

#### Password Hashing
This demo implements a **double SHA256 hashing scheme** to protect passwords during transmission:

```javascript
// Client-side (login.xs)
passwordHash = SHA256(accName + SHA256(password))

// Example for "admin" with password "admin123":
// Step 1: SHA256("admin123") → hash1
// Step 2: SHA256("admin" + hash1) → final passwordHash sent to server
```

#### AuthKey Generation & Verification

**Deterministic** authKey - it can be regenerated and verified without storing session data:

```javascript
// Server generates (authorize.xs)
authKey = SHA256(accName + FIXED_SECRET)

// Server verifies (authModule.js)
expectedAuthKey = SHA256(cookies.accName + FIXED_SECRET)
isValid = (cookies.authKey === expectedAuthKey)
```

**Benefits:**
- No database or session store required
- Stateless authentication
- Cannot be forged without knowing `FIXED_SECRET`
- Fast verification (just a hash comparison)

**Cookies stored:**
- `authKey`: The authentication token
- `accName`: Username (needed to regenerate authKey for verification)

## Project Structure

```
wa-login/
├── themes/
│   ├── authModule.js           # Authorization validation logic
│   └── default/
│       ├── layout/
│       │   └── default.xs      # Default layout template
│       ├── pages/
│       │   ├── login.xs        # Login page
│       │   └── main.xs         # Protected welcome page
│       └── palets/
│           └── backend/
│               └── authorize.xs # Credential verification endpoint
├── assets/                     # Static files (CSS, JS, images)
├── doc/references/             # wnode coding patterns and documentation
├── CLAUDE.md                   # AI coding assistant configuration
└── package.json
```

## Key Features

### Security
- **Password hashing**: Client-side double SHA256 hashing prevents plain text transmission
- **Deterministic authKey**: `SHA256(accName + FIXED_SECRET)` allows verification without storage
- **No password storage**: Server compares password hashes, never stores plain text passwords
- **Cookie-based authentication**: Secure token storage with 7-day expiration and SameSite=Strict
- **Web Crypto API**: Uses browser's native crypto for secure client-side hashing

### Framework Features
- **Automatic authorization**: wnode's built-in mechanism protects pages without manual checks
- **Flexible design**: Developers choose which cookies to use for authorization
- **Clean separation**: `.xs` files for HTML generation, `.js` files for pure logic
- **Bootstrap 5 styling**: Modern, responsive UI with gradient themes
- **Array-based credentials**: Easy to add users without code changes

## Development

### Available Scripts
- `npm run lint` - Check code quality with ESLint
- `npm run lint:fix` - Automatically fix linting issues

### Project Configuration
- **Name**: wa-login (wnode authentication demo)
- **License**: MIT
- **Framework**: wnode with Bootstrap 5 integration

## License

MIT
