pub contract ListedPairs {
  pub struct PairInfo {
    pub var name: String;
    pub var token0: String;
    pub var token1: String;
    pub var address: Address;
    pub var liquidityToken: String?;

    init(name: String, token0: String, token1: String, address: Address, liquidityToken: String?) {
      self.name = name
      self.token0 = token0
      self.token1 = token1
      self.address = address
      self.liquidityToken = liquidityToken
    }

    pub fun update(address: Address?, liquidityToken: String?) {
      self.address = address ?? self.address
      self.liquidityToken = liquidityToken ?? self.liquidityToken
    }
  }

  pub var _pairs: { String: PairInfo };

  pub fun pairExists(name: String): Bool {
    return self._pairs.containsKey(name)
  }

  pub fun addPair(name: String, token0: String, token1: String, address: Address, liquidityToken: String?) {
    if (self._pairs.containsKey(name)) {
      return;
    }

    self._pairs[name] = PairInfo(
      name: name,
      token0: token0,
      token1: token1,
      address: address, 
      liquidityToken: liquidityToken,
    )
  }

  pub fun removePair(name: String) {
    self._pairs.remove(key: name)
  }

  pub fun updatePair(name: String, address: Address?, liquidityToken: String?) {
    self._pairs[name]!.update(address: address, liquidityToken: liquidityToken)
  }

  pub fun getPairs(): [PairInfo] {
    return self._pairs.values
  }

  init () {
    self._pairs = {}
  }
}