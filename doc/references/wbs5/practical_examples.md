# WBS5 Practical Examples

Real-world usage patterns and examples from source code analysis.

## Login Form Example

Complete login form using WBS5 components:

```javascript
exports.view = function(model, ctx) {
    const bs5 = require('bs5:main')
    const bsForm = require('bs5:form')

    // Create form controls
    const usernameControl = bsForm.makeControl({
        type: 'text',
        label: 'Username',
        name: 'username',
        required: true,
        placeholder: 'Enter your username',
        prop: {
            'autocomplete': 'username'
        }
    })

    const passwordControl = bsForm.makeControl({
        type: 'password',
        label: 'Password',
        name: 'password',
        required: true,
        placeholder: 'Enter your password',
        prop: {
            'autocomplete': 'current-password'
        }
    })

    const loginButton = bsForm.makeWidget({
        type: 'button',
        prop: {
            class: 'btn btn-primary btn-lg w-100',
            type: 'submit'
        },
        on: {
            event: 'click',
            handler: 'this.handleLogin'
        }
    }).addText('Sign In')

    return xs.root('div', {class: 'min-vh-100 d-flex align-items-center justify-content-center bg-light'})
        .add(
            xs.div({class: 'container'})
                .add(
                    xs.div({class: 'row justify-content-center'})
                        .add(
                            xs.div({class: 'col-lg-4 col-md-6 col-sm-8'})
                                .add(
                                    xs.div({class: 'card shadow-lg border-0'})
                                        .add(
                                            xs.div({class: 'card-header bg-primary text-white text-center py-4'})
                                                .add(xs.e('h3', {class: 'mb-0'}, 'App Login'))
                                        )
                                        .add(
                                            xs.div({class: 'card-body p-4'})
                                                .add(
                                                    xs.e('form', {id: 'loginForm'})
                                                        .add(
                                                            xs.div({class: 'mb-3'})
                                                                .add(usernameControl.label)
                                                                .add(usernameControl.input)
                                                        )
                                                        .add(
                                                            xs.div({class: 'mb-4'})
                                                                .add(passwordControl.label)
                                                                .add(passwordControl.input)
                                                        )
                                                        .add(loginButton)
                                                )
                                                .add(xs.div({id: 'errorMessage', style: 'display: none;'}))
                                        )
                                )
                        )
                )
        )
}

exports.control = function(p, model, ctx) {
    p.handleLogin = function(event) {
        event.preventDefault()

        const username = p.find('#username').val()
        const password = p.find('#password').val()

        if (!username || !password) {
            p.showError('Please enter both username and password')
            return
        }

        // Login logic here
    }

    p.showError = function(message) {
        const bs5 = require('bs5:main')
        const alertElement = bs5.alert('danger', message)
        p.find('#errorMessage').empty().append(alertElement).show()
    }
}
```

## Dashboard with Navigation

Dashboard layout with navbar and content:

```javascript
exports.view = function(model, ctx) {
    const bs5 = require('bs5:main')

    // Create navbar
    const brand = bs5.navbarBrand('Dashboard', '/')
    const navItems = [
        bs5.navbarItem({value: 'Home', link: '/', active: true}),
        bs5.navbarItem({value: 'Users', link: '/users'}),
        bs5.navbarItem({value: 'Settings', link: '/settings'})
    ]

    const navbar = bs5.navbar(brand, navItems, {
        darkTheme: true,
        class: 'navbar-expand-lg'
    })

    // Create alerts for notifications
    const successAlert = bs5.alert('success', 'Welcome back!')

    return xs.root('div')
        .add(navbar)
        .add(
            xs.div({class: 'container-fluid mt-4'})
                .add(successAlert)
                .add(xs.div({id: 'mainContent'}, 'Dashboard content here'))
        )
}
```

## Data Form with Validation

Complex form with multiple input types:

```javascript
exports.view = function(model, ctx) {
    const bsForm = require('bs5:form')

    // Text inputs
    const nameControl = bsForm.makeControl({
        type: 'text',
        label: 'Full Name',
        name: 'fullName',
        required: true,
        prop: {class: 'form-control-lg'}
    })

    const emailControl = bsForm.makeControl({
        type: 'email',
        label: 'Email Address',
        name: 'email',
        required: true
    })

    // Select dropdown
    const countrySelect = bsForm.makeSelect([
        {label: 'United States', value: 'US'},
        {label: 'Canada', value: 'CA'},
        {label: 'United Kingdom', value: 'UK'}
    ], {
        class: 'form-select',
        prop: {name: 'country'}
    })

    // Checkbox
    const agreeControl = bsForm.makeControl({
        type: 'checkbox',
        label: 'I agree to the terms and conditions',
        name: 'agree',
        value: 'yes',
        required: true
    })

    // Submit button
    const submitButton = bsForm.makeWidget({
        type: 'button',
        prop: {
            class: 'btn btn-primary',
            type: 'submit'
        },
        on: {
            event: 'click',
            handler: 'this.handleSubmit'
        }
    }).addText('Submit')

    return xs.root('div', {class: 'container mt-4'})
        .add(
            xs.div({class: 'row justify-content-center'})
                .add(
                    xs.div({class: 'col-md-8'})
                        .add(
                            xs.div({class: 'card'})
                                .add(
                                    xs.div({class: 'card-header'})
                                        .add(xs.e('h4', {}, 'User Registration'))
                                )
                                .add(
                                    xs.div({class: 'card-body'})
                                        .add(
                                            xs.e('form', {id: 'userForm'})
                                                .add(
                                                    xs.div({class: 'row'})
                                                        .add(
                                                            xs.div({class: 'col-md-6 mb-3'})
                                                                .add(nameControl.label)
                                                                .add(nameControl.input)
                                                        )
                                                        .add(
                                                            xs.div({class: 'col-md-6 mb-3'})
                                                                .add(emailControl.label)
                                                                .add(emailControl.input)
                                                        )
                                                )
                                                .add(
                                                    xs.div({class: 'mb-3'})
                                                        .add(xs.e('label', {class: 'form-label'}, 'Country'))
                                                        .add(countrySelect)
                                                )
                                                .add(
                                                    xs.div({class: 'form-check mb-3'})
                                                        .add(agreeControl.input)
                                                        .add(agreeControl.label)
                                                )
                                                .add(
                                                    xs.div({class: 'text-end'})
                                                        .add(submitButton)
                                                )
                                        )
                                )
                        )
                )
        )
}
```

## Settings Page with Accordion

Settings organized with accordion sections:

```javascript
exports.view = function(model, ctx) {
    const bs5 = require('bs5:main')
    const bsForm = require('bs5:form')

    // Create settings sections
    const generalSettings = xs.div()
        .add(bsForm.makeControl({
            type: 'text',
            label: 'Site Title',
            name: 'siteTitle',
            value: model.settings.title
        }))

    const securitySettings = xs.div()
        .add(bsForm.makeControl({
            type: 'switch',
            label: 'Enable Two-Factor Authentication',
            name: 'twoFactor',
            checked: model.settings.twoFactor
        }))

    const accordion = bs5.accordion([
        {
            header: 'General Settings',
            body: generalSettings,
            show: true
        },
        {
            header: 'Security Settings',
            body: securitySettings,
            show: false
        }
    ], {
        flush: false,
        alwaysOpen: false
    })

    return xs.root('div', {class: 'container mt-4'})
        .add(xs.e('h2', {}, 'Settings'))
        .add(accordion)
}
```

## Error Handling Patterns

Consistent error display across components:

```javascript
exports.control = function(p, model, ctx) {
    p.showSuccess = function(message) {
        const bs5 = require('bs5:main')
        const alert = bs5.alert('success', message)
        p.find('#alertContainer').empty().append(alert).show()
    }

    p.showError = function(message) {
        const bs5 = require('bs5:main')
        const alert = bs5.alert('danger', message)
        p.find('#alertContainer').empty().append(alert).show()
    }

    p.showWarning = function(message) {
        const bs5 = require('bs5:main')
        const alert = bs5.alert('warning', message)
        p.find('#alertContainer').empty().append(alert).show()
    }

    p.clearAlerts = function() {
        p.find('#alertContainer').empty().hide()
    }
}
```

## Best Practices Summary

1. **Consistent Module Loading**: Always load `bs5:main` and `bs5:form` at the start of view functions
2. **Form Structure**: Use `makeControl()` for complete form fields, wrap in proper Bootstrap containers
3. **Error Handling**: Create reusable alert functions in control section
4. **Responsive Design**: Use Bootstrap grid classes for responsive layouts
5. **Event Handling**: Define event handlers in control section, reference them in view
6. **Accessibility**: Include proper labels, IDs, and ARIA attributes
7. **Validation**: Implement both client-side and server-side validation patterns