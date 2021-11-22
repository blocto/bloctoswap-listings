
require('dotenv').config()

const ADDRESS = process.env.ADDRESS

const removePair = `
import ListedPairs from ${ADDRESS}

transaction(key: String) {
  execute {
    ListedPairs.removePair(key: key)
  }
}
`

module.exports = removePair
