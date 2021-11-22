import ListedPairs from 0x217b60138188a81d

pub contract TestListedPairs {
  pub fun testAddPair(): [ListedPairs.PairInfo] {
    ListedPairs.addPair(
      name: "FlowSwapPair",
      token0: "Flow",
      token1: "tUSDT",
      address: 0xd9854329b7edf136,
      liquidityToken: nil
    );
    return ListedPairs.getPairs()
  }

  pub fun testUpdatePair(): [ListedPairs.PairInfo] {
    ListedPairs.updatePair(
      name: "FlowSwapPair",
      address: 0xd9854329b7edf136,
      liquidityToken: "testToken"
    );
    return ListedPairs.getPairs()
  }

  pub fun testRemovePair(): [ListedPairs.PairInfo] {
    ListedPairs.removePair(key: "FlowSwapPair.0xd9854329b7edf136");
    return ListedPairs.getPairs()
  }
}