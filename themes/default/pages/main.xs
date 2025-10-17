exports.view = function() {
    return xs.root('div', css())
        .add(
            xs.div({class: 'min-vh-100 d-flex flex-column main-bg'}, [
                createHeader(),
                createMainContent()
            ])
        )
}

exports.control = function(p, model, ctx) {
    p.startup = function() {
        // Could check for authentication here
        // If not authenticated, redirect to login
    }

    p.logout = function() {
        // Clear both authKey and accName cookies
        document.cookie = 'authKey=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/; SameSite=Strict'
        document.cookie = 'accName=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/; SameSite=Strict'

        // Redirect to login page
        window.location.href = '/login'
    }
}

function createHeader() {
    return xs.div({class: 'bg-white shadow-sm border-bottom'},
        xs.div({class: 'container'},
            xs.div({class: 'row'},
                xs.div({class: 'col-12 py-3 d-flex justify-content-between align-items-center'}, [
                    xs.e('h4', {class: 'mb-0 fw-bold text-primary'}, 'Secure Application'),
                    xs.e('button', {
                        id: 'logoutBtn',
                        class: 'btn btn-outline-danger btn-sm',
                        type: 'button'
                    }, 'Logout').on('click', 'this.logout')
                ])
            )
        )
    )
}

function createMainContent() {
    return xs.div({class: 'container flex-grow-1 py-5'},
        xs.div({class: 'row justify-content-center'},
            xs.div({class: 'col-lg-8'}, [
                createWelcomeCard(),
                createFeaturesCard()
            ])
        )
    )
}

function createWelcomeCard() {
    return xs.div({class: 'card shadow-sm border-0 rounded-3 mb-4'}, [
        xs.div({class: 'card-body p-5 text-center welcome-card'}, [
            xs.e('div', {class: 'mb-4'},
                xs.e('i', {class: 'bi bi-check-circle-fill text-success', style: 'font-size: 4rem'})
            ),
            xs.e('h1', {class: 'mb-3 fw-bold'}, 'Welcome!'),
            xs.e('p', {class: 'lead text-muted mb-0'},
                'You have successfully logged in to the system.'
            )
        ])
    ])
}

function createFeaturesCard() {
    return xs.div({class: 'card shadow-sm border-0 rounded-3'}, [
        xs.div({class: 'card-header bg-primary text-white py-3'},
            xs.e('h5', {class: 'mb-0 fw-semibold'}, 'Authorized Access')
        ),
        xs.div({class: 'card-body p-4'}, [
            xs.e('p', {class: 'mb-4'},
                'As an authorized user, you now have access to:'
            ),
            xs.e('ul', {class: 'list-group list-group-flush'}, [
                createFeatureItem('bi-shield-check', 'Restricted Pages', 'Access protected content and resources'),
                createFeatureItem('bi-gear', 'Advanced Features', 'Use premium functionality and tools'),
                createFeatureItem('bi-file-lock', 'Secure Data', 'View and manage sensitive information'),
                createFeatureItem('bi-people', 'User Management', 'Manage users and permissions (admin only)')
            ])
        ])
    ])
}

function createFeatureItem(icon, title, description) {
    return xs.e('li', {class: 'list-group-item border-0 px-0 py-3'},
        xs.div({class: 'd-flex align-items-start'}, [
            xs.div({class: 'me-3'},
                xs.e('i', {class: `bi ${icon} text-primary fs-4`})
            ),
            xs.div({}, [
                xs.e('h6', {class: 'mb-1 fw-semibold'}, title),
                xs.e('p', {class: 'mb-0 text-muted small'}, description)
            ])
        ])
    )
}

function css() {
    return {
        '.main-bg': {
            'background': 'linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%)'
        },
        '.welcome-card': {
            'background': 'linear-gradient(135deg, #667eea15 0%, #764ba215 100%)'
        },
        '.card-header.bg-primary': {
            'background': 'linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important'
        }
    }
}
