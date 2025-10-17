// use wnode's built-in bootstrap 5 utility library
const  bsForm = require('bs5:form')


exports.view = function() {
    const  loginCard = createLoginCard()

    return xs.root('div', css())
             .add(
                    xs.div({class: 'min-vh-100 d-flex align-items-center justify-content-center login-bg'},
                            xs.div({class: 'container'},
                                    xs.div({class: 'row justify-content-center'},
                                            xs.div({class: 'col-lg-4 col-md-6 col-sm-8'}, loginCard) )
                                )
                        )
                )
}


exports.control = function(p, model, ctx) {
    p.startup = function() {
        // Focus on username field
        p.find('#accName').focus()

        // Handle Enter key in form fields
        p.find('#accName, #password').on('keypress', function(e) {
            if (e.which === 13) { // Enter key
                e.preventDefault()
                p.handleLogin()
            }
        })
    }

    p.handleLogin = async function() {
        const  formData = getFormData()

        // Clear previous alerts
        p.find('#errorAlert, #successAlert').addClass('d-none')

        // Validate input
        if (!formData.accName || !formData.password) {
            showError('Please enter both username and password')
            return
        }

        // Hash the password: SHA256(accName + SHA256(password))
        const hashedPassword = await hashPassword(formData.accName, formData.password)

        // Disable login button during request
        setLoginButtonState(true, 'Signing in...')

        // Call backend authorization with hashed password
        $.post('/backend/authorize.wsj', {
            accName: formData.accName,
            passwordHash: hashedPassword
        }, function(response) {
            if (response.code === 0)
                handleLoginSuccess(response)
            else
                handleLoginError(response.message)
        }).fail(function() {
            handleLoginError('Connection error. Please try again.')
        })
    }

    function  showError(message) {
        p.find('#errorAlert .alert').text(message)
        p.find('#errorAlert').removeClass('d-none')
        p.find('#successAlert').addClass('d-none')
    }

    function  showSuccess(message) {
        p.find('#successAlert .alert').text(message)
        p.find('#successAlert').removeClass('d-none')
        p.find('#errorAlert').addClass('d-none')
    }

    function  setLoginButtonState(disabled, text) {
        p.find('#loginBtn').prop('disabled', disabled).text(text)
    }

    function  getFormData() {
        return {
            accName: p.find('[name="accName"]').val(),
            password: p.find('[name="password"]').val()
        }
    }

    async function  hashPassword(accName, password) {
        // SHA256(accName + SHA256(password))
        const passwordHash = await sha256(password)
        const finalHash = await sha256(accName + passwordHash)
        return finalHash
    }

    async function  sha256(message) {
        const msgBuffer = new TextEncoder().encode(message)
        const hashBuffer = await crypto.subtle.digest('SHA-256', msgBuffer)
        const hashArray = Array.from(new Uint8Array(hashBuffer))
        const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('')
        return hashHex
    }

    function  handleLoginSuccess(response) {
        setLoginButtonState(false, 'Sign In')
        showSuccess(response.value.message)

        const authKey = response.value.authKey
        const accName = response.value.accName

        // Save authKey and accName as cookies
        if (authKey && accName) {
            // Set cookie with 7 days expiration
            const expirationDays = 7
            const date = new Date()
            date.setTime(date.getTime() + (expirationDays * 24 * 60 * 60 * 1000))
            const expires = 'expires=' + date.toUTCString()

            document.cookie = `authKey=${authKey}; ${expires}; path=/; SameSite=Strict`
            document.cookie = `accName=${accName}; ${expires}; path=/; SameSite=Strict`
        }

        // Redirect after short delay
        setTimeout(function() {
            window.location.href = '/main'
        }, 1000)
    }

    function  handleLoginError(message) {
        setLoginButtonState(false, 'Sign In')
        showError(message || 'Login failed')
    }
}


function createLoginCard() {
    const  alerts = createAlertContainers(),
           loginForm = createLoginForm()

    return  xs.div({class: 'card shadow-lg border-0 login-card'}, [
                    xs.div({class: 'login-header text-white text-center py-4'},
                        xs.e('h3', {class: 'mb-0 fw-semibold fs-4'}, 'Login')
                    ),
                    xs.div({class: 'login-body p-4'}, [
                        loginForm,
                        alerts.errorAlert,
                        alerts.successAlert
                    ])
                ])
}


function createLoginForm() {
    const  controls = createFormControls()

    return  xs.e('form', {id: 'loginForm'}, [
                    xs.div({class: 'mb-3'}, [controls.usernameControl.label, controls.usernameControl.input]),
                    xs.div({class: 'mb-4'}, [controls.passwordControl.label, controls.passwordControl.input]),
                    controls.loginButton
                ])
}


function createFormControls() {
    const usernameControl = bsForm.makeControl({
        type: 'text',
        label: 'Username',
        name: 'accName',
        required: true,
        placeholder: 'Enter your username',
        prop: {
            id: 'accName',
            autocomplete: 'username'
        }
    })

    const passwordControl = bsForm.makeControl({
        type: 'password',
        label: 'Password',
        name: 'password',
        required: true,
        placeholder: 'Enter your password',
        prop: {
            id: 'password',
            autocomplete: 'current-password'
        }
    })

    const  loginButton = xs.e('button', {id: 'loginBtn', class: 'btn btn-primary btn-lg w-100', type: 'button'}, 'Sign In')
                           .on('click', 'this.handleLogin')

    return { usernameControl, passwordControl, loginButton }
}


function createAlertContainers() {
    const errorAlert = xs.div({id: 'errorAlert', class: 'alert-container d-none mt-3'},
        xs.div({class: 'alert alert-danger rounded-3 border-0 fw-medium mb-0'}, '')
    )

    const successAlert = xs.div({id: 'successAlert', class: 'alert-container d-none mt-3'},
        xs.div({class: 'alert alert-success rounded-3 border-0 fw-medium mb-0'}, '')
    )

    return { errorAlert, successAlert }
}


function css() {
    const  gradientBG = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'

    return {
        '.login-bg': {
            'background': gradientBG
        },
        '.login-card': {
            'overflow': 'hidden',
            'backdrop-filter': 'blur(10px)',
            'background': 'rgba(255, 255, 255, 0.95)'
        },
        '.login-header': {
            'background': gradientBG
        },
        '.login-body .form-control': {
            'transition': 'all 0.3s ease'
        },
        '.login-body .form-control:focus': {
            'border-color': '#667eea',
            'box-shadow': '0 0 0 3px rgba(102, 126, 234, 0.1)'
        },
        '.login-body .btn-primary': {
            'background': gradientBG,
            'transition': 'all 0.3s ease',
            'box-shadow': '0 4px 15px rgba(102, 126, 234, 0.4)'
        },
        '.login-body .btn-primary:hover': {
            'transform': 'translateY(-2px)',
            'box-shadow': '0 6px 20px rgba(102, 126, 234, 0.5)'
        },
        '.login-body .btn-primary:active': {
            'transform': 'translateY(0)'
        },
        '.login-body .btn-primary:disabled': {
            'cursor': 'not-allowed',
            'transform': 'none'
        },
        '.alert-container': {
            'animation': 'slideIn 0.3s ease'
        },
        '@keyframes slideIn': {
            'from': {
                'opacity': '0',
                'transform': 'translateY(-10px)'
            },
            'to': {
                'opacity': '1',
                'transform': 'translateY(0)'
            }
        }
    }
}