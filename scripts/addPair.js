
require('dotenv').config()

const ADDRESS = process.env.ADDRESS

const addPair = `
import ListedPairs from ${ADDRESS}

transaction(name: String, token0: String, token1: String, address: Address, liquidityToken: String?) {
  execute {
    ListedPairs.addPair(
      name: name,
      token0: token0,
      token1: token1,
      address: address, 
      liquidityToken: liquidityToken,
    )
  }
}
`

module.exports = addPair
