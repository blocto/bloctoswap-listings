
require('dotenv').config()

const ADDRESS = process.env.ADDRESS

const removePair = `
import ListedPairs from ${ADDRESS}

transaction(name: String) {
  execute {
    ListedPairs.removePair(name: name)
  }
}
`

module.exports = removePair
