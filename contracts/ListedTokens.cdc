pub contract ListedTokens {
  pub struct TokenInfo {
    pub var name: String;
    pub var symbol: String;
    pub var address: Address;
    pub var decimals: UInt8;
    pub var Vault: String;
    pub var TokenPublicReceiverPath: String;
    pub var TokenPublicBalancePath: String;
    pub var shouldCheckVaultExist: Bool;

    init(name: String, symbol: String, address: Address, decimals: UInt8, Vault: String, TokenPublicReceiverPath: String, TokenPublicBalancePath: String, shouldCheckVaultExist: Bool) {
      self.name = name
      self.symbol = symbol
      self.address = address
      self.decimals = decimals
      self.Vault = Vault
      self.TokenPublicReceiverPath = TokenPublicReceiverPath
      self.TokenPublicBalancePath = TokenPublicBalancePath
      self.shouldCheckVaultExist = shouldCheckVaultExist
    }
  }

  pub var _tokens: { String: TokenInfo };

  pub fun tokenExists(name: String): Bool {
    return self._tokens.containsKey(name)
  }

  pub fun addToken(name: String, symbol: String, address: Address, decimals: UInt8, Vault: String, TokenPublicReceiverPath: String, TokenPublicBalancePath: String, shouldCheckVaultExist: Bool) {
    if (self._tokens.containsKey(name)) {
      return;
    }

    self._tokens[name] = TokenInfo(
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

  pub fun removeToken(name: String) {
    self._tokens.remove(key: name)
  }

  pub fun updateToken(name: String, symbol: String, address: Address, decimals: UInt8, Vault: String, TokenPublicReceiverPath: String, TokenPublicBalancePath: String, shouldCheckVaultExist: Bool) {
    self._tokens[name] = TokenInfo(
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

  pub fun getTokens(): [TokenInfo] {
    return self._tokens.values
  }

  init () {
    self._tokens = {}
  }
}