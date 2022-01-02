
require('dotenv').config()

const ADDRESS = process.env.ADDRESS

const removePair = `
import ListedPairs from ${ADDRESS}

transaction(key: String) {
  let admin: &ListedPairs.Admin
  prepare(signer: AuthAccount) {
    self.admin = signer.borrow<&ListedPairs.Admin>(from: ListedPairs.AdminStoragePath)
      ?? panic("Could not borrow a reference to Admin")
  }
  execute {
    self.admin.removePair(key: key)
  }
}
`

module.exports = removePair
