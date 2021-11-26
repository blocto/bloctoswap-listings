## Bloctoswap Listings
By sending PR to this repo, you can list your tokens & swap pair on Bloctoswap.

### Add your token to Bloctoswap
To add you token to Bloctoswap, please add a new entry in `data/{network}/tokens.json`. 
An token entry should be in following format:
```
{
  // name of the token that is used in the contract
  "name": "TestToken",
  // an user friendly version of token name.
  "displayName": "Test Token",
  // symbol to be displayed
  "symbol": "TEST",
  "address": "0x1234567890abcde",
  "decimals": 8,
  // vault storage path
  "vaultPath": "/storage/testTokenVault",
  // receiver storage path
  "receiverPath": "/public/testTokenReceiver",
  // balance storage path
  "balancePath": "/public/testTokenBalance",
  // we use it internally, please always set it to true
  "shouldCheckVaultExist": true 
},
```

### Add new swap pair to Bloctoswap
To add you new swap pair to Bloctoswap, please add a new entry in `data/{network}/pairs.json`. 
An token entry should be in following format:
```
{
  // name of the swap pair used in the contract
  "name": "FlowTestSwapPair",
  "token0": "FlowToken",
  "token1": "TestToken",
  "address": "0x1234567890abcde",
  // optional liquidity token field
  "liquidityToken": null | "LiqudityToken"
},
```

## Review process
Please send PR to `testnet` branch first so that we can test new entries on our end. 