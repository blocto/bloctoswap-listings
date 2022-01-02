
require('dotenv').config()

const ADDRESS = process.env.ADDRESS

const updatePair = `
import ListedPairs from ${ADDRESS}

transaction(name: String, address: Address, liquidityToken: String?) {
  let admin: &ListedPairs.Admin
  prepare(signer: AuthAccount) {
    self.admin = signer.borrow<&ListedPairs.Admin>(from: ListedPairs.AdminStoragePath)
      ?? panic("Could not borrow a reference to Admin")
  }
  execute {
    self.admin.updatePair(
      name: name,
      address: address, 
      liquidityToken: liquidityToken,
    )
  }
}
`

module.exports = updatePair
