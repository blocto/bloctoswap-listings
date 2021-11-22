
const fcl = require('@onflow/fcl')
const t = require('@onflow/types')
const EC = require('elliptic').ec
const ec = new EC('p256')
const { SHA3 } = require('sha3')
const addToken = require('./scripts/addToken')
const updateToken = require('./scripts/updateToken')
const removeToken = require('./scripts/removeToken')
const addPair = require('./scripts/addPair')
const updatePair = require('./scripts/updatePair')
const removePair = require('./scripts/removePair')

require('dotenv').config()

const NETWORK = process.env.NETWORK || 'testnet'
const ACCESS_NODE = process.env.ACCESS_NODE
const ADDRESS = process.env.ADDRESS
const PRIVATE_KEY = process.env.PRIVATE_KEY

const TOKENS_LIST = require(`./data/${NETWORK}/tokens.json`)
const PAIRS_LIST = require(`./data/${NETWORK}/pairs.json`)

const signWithKey = (privateKey, msgHex) => {
  const key = ec.keyFromPrivate(Buffer.from(privateKey, 'hex'))
  const sig = key.sign(hashMsgHex(msgHex))
  const n = 32 // half of signature length?
  const r = sig.r.toArrayLike(Buffer, 'be', n)
  const s = sig.s.toArrayLike(Buffer, 'be', n)
  return Buffer.concat([r, s]).toString('hex')
}

const hashMsgHex = msgHex => {
  const sha = new SHA3(256)
  sha.update(Buffer.from(msgHex, 'hex'))
  return sha.digest()
}

// Will be handled by fcl.user(addr).info()
const getAccount = async addr => {
  const { account } = await fcl.send([fcl.getAccount(addr)])
  return account
}

const authorization = async (account = {}) => {
  const user = await getAccount(ADDRESS)
  const key = user.keys[0]

  let sequenceNum
  if (account.role && account.role.proposer) sequenceNum = key.sequenceNumber

  const signingFunction = async data => {
    return {
      addr: user.address,
      keyId: key.index,
      signature: signWithKey(PRIVATE_KEY, data.message),
    }
  }

  return {
    ...account,
    addr: user.address,
    keyId: key.index,
    sequenceNum,
    signature: account.signature || null,
    signingFunction,
    resolve: null,
    roles: account.roles,
  }
}

const executeScript = async (script, args = []) => 
  fcl
    .send([fcl.getBlock(true)])
    .then(fcl.decode)
    .then(block => fcl.send([
      fcl.transaction(script),
      fcl.args(args),
      fcl.proposer(authorization),
      fcl.payer(authorization),
      fcl.ref(block.id),
      fcl.limit(100),
    ]))
    .then(({ transactionId }) => fcl.tx(transactionId).onceSealed())
    .catch(e => {
      console.error(e)
    })

async function diffTokens() {
  const getTokensScript = `\
  import ListedTokens from ${ADDRESS}

  pub fun main(): [ListedTokens.TokenInfo] {
    return ListedTokens.getTokens()
  }`
  const onchainList = await fcl.send([fcl.script(getTokensScript)]).then(fcl.decode)
  const newTokens = TOKENS_LIST.filter(token => !onchainList.find(({ name }) => name === token.name))
  const updatedTokens = TOKENS_LIST
    .filter(token => onchainList
      .find(t => t.name === token.name && JSON.stringify(token) !== JSON.stringify(t))
    )
  const removedTokens = onchainList.filter(token => !TOKENS_LIST.find(({ name }) => name === token.name))
  return { newTokens, updatedTokens, removedTokens }
}

async function diffPairs() {
  const getPairsScript = `\
  import ListedPairs from ${ADDRESS}

  pub fun main(): [ListedPairs.PairInfo] {
    return ListedPairs.getPairs()
  }`
  const onchainList = await fcl.send([fcl.script(getPairsScript)]).then(fcl.decode)
  const newPairs = PAIRS_LIST.filter(pair => !onchainList.find(({ name }) => name === pair.name))
  const updatedPairs = PAIRS_LIST
    .filter(pair => onchainList
      .find(p => p.name === pair.name && JSON.stringify(pair) !== JSON.stringify(p))
    )
  const removedPairs = onchainList.filter(pair => !PAIRS_LIST.find(({ name }) => name === pair.name))
  return { newPairs, updatedPairs, removedPairs }
}

async function addTokens(tokens) {
  const args = tokens.map(token => [
    fcl.arg(token.name, t.String),
    fcl.arg(token.symbol, t.String),
    fcl.arg(token.address, t.Address),
    fcl.arg(token.decimals, t.UInt8),
    fcl.arg(token.Vault, t.String),
    fcl.arg(token.TokenPublicReceiverPath, t.String),
    fcl.arg(token.TokenPublicBalancePath, t.String),
    fcl.arg(token.shouldCheckVaultExist, t.Bool),
  ])
  return Promise.all(args.map(tokenArgs => executeScript(addToken, tokenArgs)))
}

async function updateTokens(tokens) {
  const args = tokens.map(token => [
    fcl.arg(token.name, t.String),
    fcl.arg(token.symbol, t.String),
    fcl.arg(token.address, t.Address),
    fcl.arg(token.decimals, t.UInt8),
    fcl.arg(token.Vault, t.String),
    fcl.arg(token.TokenPublicReceiverPath, t.String),
    fcl.arg(token.TokenPublicBalancePath, t.String),
    fcl.arg(token.shouldCheckVaultExist, t.Bool),
  ])
  return Promise.all(args.map(tokenArgs => executeScript(updateToken, tokenArgs)))
}

async function removeTokens(tokens) {
  const args = tokens.map(token => [fcl.arg(token.name, t.String) ])
  return Promise.all(args.map(tokenArgs => executeScript(removeToken, tokenArgs)))
}

async function addPairs(pairs) {
  const args = pairs.map(pair => [
    fcl.arg(pair.name, t.String),
    fcl.arg(pair.token0, t.String),
    fcl.arg(pair.token1, t.String),
    fcl.arg(pair.address, t.Address),
    fcl.arg(pair.liquidityToken, t.Optional(t.String)),
  ])
  return Promise.all(args.map(pairArgs => executeScript(addPair, pairArgs)))
}

async function updatePairs(pairs) {
  const args = pairs.map(pair => [
    fcl.arg(pair.name, t.String),
    fcl.arg(pair.address, t.Optional(t.Address)),
    fcl.arg(pair.liquidityToken, t.Optional(t.String)),
  ])
  return Promise.all(args.map(pairArgs => executeScript(updatePair, pairArgs)))
}

async function removePairs(pairs) {
  const args = pairs.map(pair => [fcl.arg(pair.name, t.String) ])
  return Promise.all(args.map(pairArgs => executeScript(removePair, pairArgs)))
}

async function main () {
  fcl.config({ "accessNode.api": ACCESS_NODE, "0xProfile": ADDRESS })
  const { newTokens, updatedTokens, removedTokens } = await diffTokens()
  const { newPairs, updatedPairs, removedPairs } = await diffPairs()

  console.log("[Info] Adding Tokens")
  await addTokens(newTokens)
  console.log("[Info] Updating Tokens")
  await updateTokens(updatedTokens)
  console.log("[Info] Removing Tokens")
  await removeTokens(removedTokens)
  console.log("[Info] Adding Pairs")
  await addPairs(newPairs)
  console.log("[Info] Updating Pairs")
  await updatePairs(updatedPairs)
  console.log("[Info] Removing Pairs")
  await removePairs(removedPairs)

  console.log("[Info] Done")
}

main()
