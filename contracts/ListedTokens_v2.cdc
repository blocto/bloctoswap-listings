pub contract ListedTokens_v2 {
  /****** Events ******/
  pub event TokenAdded(key: String, name: String, displayName: String, symbol: String, address: Address)
  pub event TokenUpdated(key: String, name: String, displayName: String, symbol: String, address: Address)
  pub event TokenRemoved(key: String)

  /****** Contract Variables ******/
  access(contract) let _tokens: { String: TokenInfo }

  pub let AdminStoragePath: StoragePath
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
    pub fun addToken(name: String, displayName: String, symbol: String, address: Address, vaultPath: String, receiverPath: String, balancePath: String) {
      ListedTokens_v2.addToken(
        name: name, 
        displayName: displayName, 
        symbol: symbol, 
        address: address, 
        vaultPath: vaultPath, 
        receiverPath: receiverPath, 
        balancePath: balancePath, 
        creatorAddress: self.owner!.address
      )
    }

    pub fun updateToken(name: String, displayName: String, symbol: String, address: Address, vaultPath: String, receiverPath: String, balancePath: String) {
      let token = ListedTokens_v2.getToken(name: name, address: address)

      if (self.owner!.address != token.creatorAddress) {
        panic("Access denied. Only the proposer for listing this token and the admin are allowed to update it.")
      }

      ListedTokens_v2.updateToken(
        name: name, 
        displayName: displayName, 
        symbol: symbol, 
        address: address, 
        vaultPath: vaultPath, 
        receiverPath: receiverPath, 
        balancePath: balancePath
      )
    }

    pub fun removeToken(name: String, address: Address) {
      let token = ListedTokens_v2.getToken(name: name, address: address)
     
      if (self.owner!.address != token.creatorAddress) {
        panic("Access denied. Only the proposer for listing this token and the admin are allowed to remove it.")
      }

      ListedTokens_v2.removeToken(name: name, address: address)
    }
  }

  pub resource Admin {
    pub fun addToken(name: String, displayName: String, symbol: String, address: Address, vaultPath: String, receiverPath: String, balancePath: String) {
      ListedTokens_v2.addToken(
        name: name, 
        displayName: displayName, 
        symbol: symbol, 
        address: address, 
        vaultPath: vaultPath, 
        receiverPath: receiverPath, 
        balancePath: balancePath, 
        creatorAddress: self.owner!.address
      )
    }

    pub fun updateToken(name: String, displayName: String, symbol: String, address: Address, vaultPath: String, receiverPath: String, balancePath: String) {
      ListedTokens_v2.updateToken(
        name: name, 
        displayName: displayName, 
        symbol: symbol, 
        address: address, 
        vaultPath: vaultPath, 
        receiverPath: receiverPath, 
        balancePath: balancePath
      )
    }

    pub fun removeToken(name: String, address: Address) {
      ListedTokens_v2.removeToken(name: name, address: address)
    }
  }

  /****** Methods ******/
  pub fun tokenExists(key: String): Bool {
    return self._tokens.containsKey(key)
  }

  pub fun getTokenKey(name: String, address: Address): String {
    return name.concat(".").concat(address.toString())
  }

  pub fun getTokens(): [TokenInfo] {
    return self._tokens.values
  }

  pub fun getToken(name: String, address: Address): TokenInfo {
    let key = self.getTokenKey(name: name, address: address)
    return self._tokens[key] ?? panic("Token not found")
  }

  pub fun createTokenProposer(): @TokenProposer {
    return <- create TokenProposer()
  }

  access(self) fun addToken(name: String, displayName: String, symbol: String, address: Address, vaultPath: String, receiverPath: String, balancePath: String, creatorAddress: Address) {
    let key = self.getTokenKey(name: name, address: address)

    if (self.tokenExists(key: key)) {
      panic("Token existed!")
    }

    self._tokens[key] = TokenInfo(
      name: name,
      displayName: displayName,
      symbol: symbol,
      address: address,
      vaultPath: vaultPath,
      receiverPath: receiverPath,
      balancePath: balancePath,
      creatorAddress: creatorAddress
    )

    emit TokenAdded(key: key, name: name, displayName: displayName, symbol: symbol, address: address)
  }

  access(self) fun updateToken(name: String, displayName: String, symbol: String, address: Address, vaultPath: String, receiverPath: String, balancePath: String) {
    let key = self.getTokenKey(name: name, address: address)
    let token = self._tokens[key] ?? panic("Token not found")

    self._tokens[key] = TokenInfo(
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

  access(self) fun removeToken(name: String, address: Address) {
    let key = self.getTokenKey(name: name, address: address)
    let token = self._tokens[key] ?? panic("Token not found")

    self._tokens.remove(key: key)

    emit TokenRemoved(key: key)
  }

  init () {
    self._tokens = {}
    self.AdminStoragePath = /storage/bloctoSwapListedTokensAdmin_v2
    self.TokenProposerStoragePath = /storage/bloctoSwapTokenProposer

    let admin <- create Admin()
    self.account.save(<-admin, to: self.AdminStoragePath)
  }
}