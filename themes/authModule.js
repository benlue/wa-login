const crypto = require('crypto')

exports.isAuthorized = function(cookies)  {
    // Verify authKey by regenerating it from accName
    if (!cookies.authKey || !cookies.accName) {
        return false
    }

    // Regenerate authKey: SHA256(accName + FIXED_SECRET)
    const FIXED_SECRET = 'wnode_auth_secret_key_2024'
    const expectedAuthKey = crypto.createHash('sha256')
        .update(cookies.accName + FIXED_SECRET)
        .digest('hex')

    return cookies.authKey === expectedAuthKey
}