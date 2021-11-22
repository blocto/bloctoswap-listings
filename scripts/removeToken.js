
require('dotenv').config()

const ADDRESS = process.env.ADDRESS

const removeToken = `
import ListedTokens from ${ADDRESS}

transaction(name: String) {
  execute {
    ListedTokens.removeToken(name: name)
  }
}
`

module.exports = removeToken
