pub contract ListedTokens_v2 {
  /****** Events ******/
  pub event TokenAdded(key: String, name: String, displayName: String, symbol: String, address: Address)
  pub event TokenUpdated(key: String, name: String, displayName: String, symbol: String, address: Address)
  pub event TokenRemoved(key: String)

  /****** Contract Variables ******/
  access(contract) let _tokens: { String: TokenInfo }

  pub let AdminStoragePath: StoragePath
  pub let AdminPrivatePath: PrivatePath
  pub let TokenProposerStoragePath: StoragePath

  /****** Composite Type Definitions ******/
  pub struct TokenInfo {
    pub let name: String
    pub let displayName: String
    pub let symbol: String
    pub let address: Address
    pub let vaultPath: String
    pub let receiverPath: String
    pub let balancePath: String
    access(contract) let creatorAddress: Address

    init(name: String, displayName: String, symbol: String, address: Address, vaultPath: String, receiverPath: String, balancePath: String, creatorAddress: Address) {
      self.name = name
      self.displayName = displayName
      self.symbol = symbol
      self.address = address
      self.vaultPath = vaultPath
      self.receiverPath = receiverPath
      self.balancePath = balancePath
      self.creatorAddress = creatorAddress
    }
  }

  pub resource TokenProposer {
  }

  pub resource interface TokenAdmin {
    pub fun addToken(name: String, displayName: String, symbol: String, address: Address, vaultPath: String, receiverPath: String, balancePath: String, creatorResource: &TokenProposer)

    pub fun updateToken(name: String, displayName: String, symbol: String, address: Address, vaultPath: String, receiverPath: String, balancePath: String, proposerResource: &TokenProposer)
        
    pub fun removeToken(name: String, address: Address, proposerResource: &TokenProposer)
  }

  pub resource Admin: TokenAdmin {
    pub fun addToken(name: String, displayName: String, symbol: String, address: Address, vaultPath: String, receiverPath: String, balancePath: String, creatorResource: &TokenProposer) {
      let key = name.concat(".").concat(address.toString())

      if (ListedTokens_v2.tokenExists(key: key)) {
        panic("Token existed!")
      }

      ListedTokens_v2._tokens[key] = TokenInfo(
        name: name,
        displayName: displayName,
        symbol: symbol,
        address: address,
        vaultPath: vaultPath,
        receiverPath: receiverPath,
        balancePath: balancePath,
        creatorAddress: creatorResource.owner!.address
      )

      emit TokenAdded(key: key, name: name, displayName: displayName, symbol: symbol, address: address)
    }

    pub fun updateToken(name: String, displayName: String, symbol: String, address: Address, vaultPath: String, receiverPath: String, balancePath: String, proposerResource: &TokenProposer) {
      let key = name.concat(".").concat(address.toString())
      let token = ListedTokens_v2._tokens[key] ?? panic("Token not found")

      if (proposerResource.owner!.address != token.creatorAddress && proposerResource.owner!.address != ListedTokens_v2.account.address) {
        panic("Access denied. Only the proposer for listing this token and the admin are allowed to update it.")
      }

      ListedTokens_v2._tokens[key] = TokenInfo(
        name: name,
        displayName: displayName,
        symbol: symbol,
        address: address,
        vaultPath: vaultPath,
        receiverPath: receiverPath,
        balancePath: balancePath,
        creatorAddress: token.creatorAddress
      )

      emit TokenUpdated(key: key, name: name, displayName: displayName, symbol: symbol, address: address)
    }

    pub fun removeToken(name: String, address: Address, proposerResource: &TokenProposer) {
      let key = name.concat(".").concat(address.toString())
      let token = ListedTokens_v2._tokens[key] ?? panic("Token not found")

      if (proposerResource.owner!.address != token.creatorAddress && proposerResource.owner!.address != ListedTokens_v2.account.address) {
        panic("Access denied. Only the proposer for listing this token and the admin are allowed to remove it.")
      }

      ListedTokens_v2._tokens.remove(key: key)

      emit TokenRemoved(key: key)
    }
  }

  /****** Methods ******/
  pub fun tokenExists(key: String): Bool {
    return self._tokens.containsKey(key)
  }

  pub fun getTokens(): [TokenInfo] {
    return self._tokens.values
  }

  pub fun createTokenProposer(): @TokenProposer {
    return <- create TokenProposer()
  }

  init () {
    self._tokens = {}
    self.AdminStoragePath = /storage/bloctoSwapListedTokensAdmin_v2
    self.AdminPrivatePath = /private/bloctoSwapListedTokensAdmin_v2
    self.TokenProposerStoragePath = /storage/bloctoSwapTokenProposer

    let admin <- create Admin()
    self.account.save(<-admin, to: self.AdminStoragePath)

    let tokenProposer <- create TokenProposer()
    self.account.save<@TokenProposer>(<-tokenProposer, to: self.TokenProposerStoragePath)
    
    self.account.link<&{TokenAdmin}>(self.AdminPrivatePath, target: self.AdminStoragePath)
  }
}