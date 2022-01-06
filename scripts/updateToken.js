
require('dotenv').config()

const ADDRESS = process.env.ADDRESS

const updateToken = `
import ListedTokens from ${ADDRESS}

transaction(name: String, displayName: String, symbol: String, address: Address, vaultPath: String, receiverPath: String, balancePath: String) {
  let admin: &ListedTokens.Admin
  prepare(signer: AuthAccount) {
    self.admin = signer.borrow<&ListedTokens.Admin>(from: ListedTokens.AdminStoragePath)
      ?? panic("Could not borrow a reference to Admin")
  }
  execute {
    self.admin.updateToken(
      name: name,
      displayName: displayName,
      symbol: symbol,
      address: address, 
      vaultPath: vaultPath,
      receiverPath: receiverPath, 
      balancePath: balancePath, 
    )
  }
}
`

module.exports = updateToken
