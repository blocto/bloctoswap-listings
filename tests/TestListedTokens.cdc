import ListedTokens from 0x3ccc6ebed5d673f3

pub contract TestListedTokens {
  pub fun testAddToken(): [ListedTokens.TokenInfo] {
    ListedTokens.addToken(
      name: "FUSD",
      symbol: "FUSD",
      address: 0x00000000,
      decimals: 8,
      Vault: "/storage/fusdVault",
      TokenPublicReceiverPath: "/public/fusdReceiver",
      TokenPublicBalancePath: "/public/fusdBalance",
      shouldCheckVaultExist: true
    );
    return ListedTokens.getTokens()
  }

  pub fun testUpdateToken(): [ListedTokens.TokenInfo] {
    ListedTokens.updateToken(
      name: "FUSD",
      symbol: "FUSD",
      address: 0x00000001,
      decimals: 8,
      Vault: "/storage/fusdVault",
      TokenPublicReceiverPath: "/public/fusdReceiver",
      TokenPublicBalancePath: "/public/fusdBalance",
      shouldCheckVaultExist: true
    );
    return ListedTokens.getTokens()
  }

  pub fun testRemoveToken(): [ListedTokens.TokenInfo] {
    ListedTokens.removeToken(name: "FUSD");
    return ListedTokens.getTokens()
  }
}