import ListedTokens from 0x217b60138188a81d

pub contract TestListedTokens {
  pub fun testAddToken(): [ListedTokens.TokenInfo] {
    ListedTokens.addToken(
      name: "FUSD",
      displayName: "Flow USD",
      symbol: "FUSD",
      address: 0x3c5959b568896393,
      decimals: 8,
      vaultPath: "/storage/fusdVault",
      receiverPath: "/public/fusdReceiver",
      balancePath: "/public/fusdBalance",
      shouldCheckVaultExist: true
    );
    return ListedTokens.getTokens()
  }

  pub fun testUpdateToken(): [ListedTokens.TokenInfo] {
    ListedTokens.updateToken(
      name: "FUSD",
      displayName: "Flow USD",
      symbol: "FUSD",
      address: 0x3c5959b568896393,
      decimals: 8,
      vaultPath: "/storage/fusdVault",
      receiverPath: "/public/fusdReceiver",
      balancePath: "/public/fusdBalance",
      shouldCheckVaultExist: false
    );
    return ListedTokens.getTokens()
  }

  pub fun testRemoveToken(): [ListedTokens.TokenInfo] {
    ListedTokens.removeToken(key: "FUSD.0x3c5959b568896393");
    return ListedTokens.getTokens()
  }
}