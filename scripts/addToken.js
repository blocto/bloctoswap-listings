
require('dotenv').config()

const ADDRESS = process.env.ADDRESS

const addTokens = `
import ListedTokens from ${ADDRESS}

transaction(name: String, symbol: String, address: Address, decimals: UInt8, Vault: String, TokenPublicReceiverPath: String, TokenPublicBalancePath: String, shouldCheckVaultExist: Bool) {
  execute {
    ListedTokens.addToken(
      name: name, 
      symbol: symbol,
      address: address, 
      decimals: decimals,
      Vault: Vault,
      TokenPublicReceiverPath: TokenPublicReceiverPath, 
      TokenPublicBalancePath: TokenPublicBalancePath, 
      shouldCheckVaultExist: shouldCheckVaultExist
    )
  }
}
`

module.exports = addTokens
