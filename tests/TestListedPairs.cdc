import ListedPairs from 0x3ccc6ebed5d673f3

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
      address: 0xd9854329b7edf131,
      liquidityToken: nil
    );
    return ListedPairs.getPairs()
  }

  pub fun testRemovePair(): [ListedPairs.PairInfo] {
    ListedPairs.removePair(name: "FlowSwapPair");
    return ListedPairs.getPairs()
  }
}