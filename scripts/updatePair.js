
require('dotenv').config()

const ADDRESS = process.env.ADDRESS

const updatePair = `
import ListedPairs from ${ADDRESS}

transaction(name: String, address: Address?, liquidityToken: String?) {
  execute {
    ListedPairs.updatePair(
      name: name,
      address: address, 
      liquidityToken: liquidityToken,
    )
  }
}
`

module.exports = updatePair
