exports.checkIn = {
    accName: {
        '@type': 'string',
        '@required': true,
        '@explain': 'Account name/username'
    },
    passwordHash: {
        '@type': 'string',
        '@required': true,
        '@explain': 'Hashed password: SHA256(accName + SHA256(password))'
    }
}


exports.model = function(inData) {
    const crypto = require('crypto')
    const { accName, passwordHash } = inData

    // Valid credentials with pre-computed password hashes
    // Hash format: SHA256(accName + SHA256(password))
    // admin: SHA256('admin' + SHA256('admin123'))
    // user: SHA256('user' + SHA256('user123'))
    const validCredentials = [
        {
            accName: 'admin',
            passwordHash: computePasswordHash('admin', 'admin123'),
            role: 'admin'
        },
        {
            accName: 'user',
            passwordHash: computePasswordHash('user', 'user123'),
            role: 'user'
        }
    ]

    // Helper function to compute password hash
    function computePasswordHash(accName, password) {
        const passwordSha = crypto.createHash('sha256').update(password).digest('hex')
        const finalHash = crypto.createHash('sha256').update(accName + passwordSha).digest('hex')
        return finalHash
    }

    // Find matching credentials
    const matchedUser = validCredentials.find(
        cred => cred.accName === accName && cred.passwordHash === passwordHash
    )

    if (matchedUser) {
        // Generate deterministic authKey: SHA256(accName + FIXED_SECRET)
        const FIXED_SECRET = 'wnode_auth_secret_key_2024'
        const authKey = crypto.createHash('sha256')
            .update(matchedUser.accName + FIXED_SECRET)
            .digest('hex')

        return  {
            code: 0,
            value: {
                message: 'Login successful',
                authKey: authKey,
                accName: matchedUser.accName,
                user: {
                    accName: matchedUser.accName,
                    role: matchedUser.role
                }
            }
        }
    }
    else {
        return  {
            code: 1,
            message: 'Invalid username or password'
        }
    }
}
