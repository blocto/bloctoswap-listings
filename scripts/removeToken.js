
require('dotenv').config()

const ADDRESS = process.env.ADDRESS

const removeToken = `
import ListedTokens from ${ADDRESS}

transaction(key: String) {
  let admin: &ListedTokens.Admin
  prepare(signer: AuthAccount) {
    self.admin = signer.borrow<&ListedTokens.Admin>(from: ListedTokens.AdminStoragePath)
      ?? panic("Could not borrow a reference to Admin")
  }
  execute {
    self.admin.removeToken(key: key)
  }
}
`

module.exports = removeToken
