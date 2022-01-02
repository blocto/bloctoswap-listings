pub contract ListedTokens {
  pub let AdminStoragePath: StoragePath;

  pub resource Admin {
    pub fun addToken(name: String, displayName: String, symbol: String, address: Address, vaultPath: String, receiverPath: String, balancePath: String) {
      var key = name.concat(".").concat(address.toString())
      if (ListedTokens._tokens.containsKey(key)) {
        return;
      }

      ListedTokens._tokens[key] = TokenInfo(
        name: name, 
        displayName: displayName, 
        symbol: symbol,
        address: address, 
        vaultPath: vaultPath,
        receiverPath: receiverPath, 
        balancePath: balancePath, 
      )
    }

    pub fun removeToken(key: String) {
      ListedTokens._tokens.remove(key: key)
    }

    pub fun updateToken(name: String, displayName: String, symbol: String, address: Address, vaultPath: String, receiverPath: String, balancePath: String) {
      var key = name.concat(".").concat(address.toString())
      ListedTokens._tokens[key] = TokenInfo(
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

  pub struct TokenInfo {
    pub var name: String;
    pub var displayName: String;
    pub var symbol: String;
    pub var address: Address;
    pub var vaultPath: String;
    pub var receiverPath: String;
    pub var balancePath: String;

    init(name: String, displayName: String,  symbol: String, address: Address, vaultPath: String, receiverPath: String, balancePath: String) {
      self.name = name
      self.displayName = displayName
      self.symbol = symbol
      self.address = address
      self.vaultPath = vaultPath
      self.receiverPath = receiverPath
      self.balancePath = balancePath
    }
  }

  pub var _tokens: { String: TokenInfo };

  pub fun tokenExists(key: String): Bool {
    return self._tokens.containsKey(key)
  }

  pub fun getTokens(): [TokenInfo] {
    return self._tokens.values
  }

  init () {
    self.AdminStoragePath = /storage/bloctoSwapListedTokensAdmin
    let admin <- create Admin()
    self.account.save(<-admin, to: self.AdminStoragePath)

    self._tokens = {}
  }
}