pub contract ListedTokens {
  pub struct TokenInfo {
    pub var name: String;
    pub var displayName: String;
    pub var symbol: String;
    pub var address: Address;
    pub var decimals: UInt8;
    pub var vaultPath: String;
    pub var receiverPath: String;
    pub var balancePath: String;
    pub var shouldCheckVaultExist: Bool;

    init(name: String, displayName: String,  symbol: String, address: Address, decimals: UInt8, vaultPath: String, receiverPath: String, balancePath: String, shouldCheckVaultExist: Bool) {
      self.name = name
      self.displayName = displayName
      self.symbol = symbol
      self.address = address
      self.decimals = decimals
      self.vaultPath = vaultPath
      self.receiverPath = receiverPath
      self.balancePath = balancePath
      self.shouldCheckVaultExist = shouldCheckVaultExist
    }
  }

  pub var _tokens: { String: TokenInfo };

  pub fun tokenExists(key: String): Bool {
    return self._tokens.containsKey(key)
  }

  pub fun addToken(name: String, displayName: String, symbol: String, address: Address, decimals: UInt8, vaultPath: String, receiverPath: String, balancePath: String, shouldCheckVaultExist: Bool) {
    var key = name.concat(".").concat(address.toString())
    if (self._tokens.containsKey(key)) {
      return;
    }

    self._tokens[key] = TokenInfo(
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

  pub fun removeToken(key: String) {
    self._tokens.remove(key: key)
  }

  pub fun updateToken(name: String, displayName: String, symbol: String, address: Address, decimals: UInt8, vaultPath: String, receiverPath: String, balancePath: String, shouldCheckVaultExist: Bool) {
    var key = name.concat(".").concat(address.toString())
    self._tokens[key] = TokenInfo(
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

  pub fun getTokens(): [TokenInfo] {
    return self._tokens.values
  }

  init () {
    self._tokens = {}
  }
}