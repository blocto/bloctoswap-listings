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

    pub fun update(liquidityToken: String?) {
      self.liquidityToken = liquidityToken ?? self.liquidityToken
    }
  }

  pub var _pairs: { String: PairInfo };

  pub fun pairExists(key: String): Bool {
    return self._pairs.containsKey(key)
  }

  pub fun addPair(name: String, token0: String, token1: String, address: Address, liquidityToken: String?) {
    var key = name.concat(".").concat(address.toString())
    if (self._pairs.containsKey(key)) {
      return;
    }

    self._pairs[key] = PairInfo(
      name: name,
      token0: token0,
      token1: token1,
      address: address, 
      liquidityToken: liquidityToken,
    )
  }

  pub fun removePair(key: String) {
    self._pairs.remove(key: key)
  }

  pub fun updatePair(name: String, address: Address, liquidityToken: String?) {
    var key = name.concat(".").concat(address.toString())
    self._pairs[key]!.update(liquidityToken: liquidityToken)
  }

  pub fun getPairs(): [PairInfo] {
    return self._pairs.values
  }

  init () {
    self._pairs = {}
  }
}