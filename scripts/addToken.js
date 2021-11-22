
require('dotenv').config()

const ADDRESS = process.env.ADDRESS

const addTokens = `
import ListedTokens from ${ADDRESS}

transaction(name: String, displayName: String, symbol: String, address: Address, decimals: UInt8, vaultPath: String, receiverPath: String, balancePath: String, shouldCheckVaultExist: Bool) {
  execute {
    ListedTokens.addToken(
      name: name, 
      displayName: displayName, 
      symbol: symbol,
      address: address, 
      decimals: decimals,
      vaultPath: vaultPath,
      receiverPath: receiverPath, 
      balancePath: balancePath, 
      shouldCheckVaultExist: shouldCheckVaultExist
    )
  }
}
`

module.exports = addTokens
