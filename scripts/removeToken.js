
require('dotenv').config()

const ADDRESS = process.env.ADDRESS

const removeToken = `
import ListedTokens from ${ADDRESS}

transaction(key: String) {
  execute {
    ListedTokens.removeToken(key: key)
  }
}
`

module.exports = removeToken
