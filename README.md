# Wormhole Hackathon Submission
  ![image](https://github.com/user-attachments/assets/d9cd7a7c-e54c-40b3-ac68-0ed22613ee4a)

# Bakeland - an on-chain MMO that puts chains at war. 
  <p align="center" width="100%">
    <img src="https://github.com/user-attachments/assets/9c172c13-c41f-4a81-8566-55e07a8ea359" width=200 height=200 align=center>
  </p>

Bakeland is an on-chain MMO where you can play against your friends and foes across multiple networks. It is currently playable as a browser game. For this hackathon, we have deployed our contracts across:

- Arbitrum Sepolia
- Avalanche Fuji
- Base Sepolia
- Binance Testnet
- Polygon Amoy

Each network has a $BUDS farm, which rewards a dynamic APR% on deposits and an instant payout for successful raids - both depending on the saturation factor (SF) of the farm. 

Saturation Factor is defined as:

SF = Local Staked $BUDS/Global Staked $BUDS

SF ∝ 1/APR%

At equilibrium, SF^E = 0.2 (given there are 5 farms)

APR% has a decay factor of λ as SF deviates from SF^E towards either 0 or 1.

This ensures that farms which are raided disproportionately cease to remain lucrative for raids. Instead, the high APR% rewards attract yield farmers onto the network.

Inversely, any farm which becomes disproportionately large, will result in dilution of $BUDS emissions on that network - while making it highly profitable to raid that network's farm. 
 

Until the team had access to Wormhole CCQ, a key blocker was the threat of transactions being frontrun given the median latency of ~50 seconds for a cross-chain message. With the use of CCQ, we now bundle cross-chain data attestations with raiding or staking transcations. This unlocks real-time composability and unique use-cases such as Bakeland's chain warfare and liquidity balancing mechanism.

While ecosystems are dutybound to incentivize native dApps, they face a paradox in the face of chain abstracted infra and applications. This is where consumer apps such as Bakeland showcase that multi-chain dApps can in fact foster a positive-sum environment. For starters, it appeals to both sets of users:

  - **Chain Agnostics** - Users moving assets freely across chains for better incentives
  - **Chain Loyalists** - Users who show a high degree of tribalism (aka chain-maximalists)


For the first time, Bakeland creates an autonomous world spanning multiple networks - and with it creates a single battleground where chains are put at war. Made possible by Wormhole.


To summarize the game:
  
Players compete to maximize their stash of $BUDS. They can do so by:

  - **Staking** - Stake $BUDS to get dynamic staking rewards.
  - **Liquid Staking** - Deposit $stBUDS to earn Liquidity Mining Incentives and BGT emissions on Berachain (not included in current implementation, awaiting CCQ deployment on bArtio V2)
  - **Raiding Farms** - Raid the farm on any chain. Probablistic function dependent a success rate derived from various factors. (powered by Supra dVRF)
  - **Bribing to Gain Booser NFTs** - Burn $BUDS for a 50% chance to mint a Booster NFT, which increases effective APR% and/or raid success odds. (powered by Supra dVRF)
  - **Fighting PvP Battles** - Wager $BUDS against other players across chain using an atomic swap escrow contract.
  
## Problem statement 

Like unified liquidity, crypto needs a unified interface. 

The problem with chain abstracted solutions is that they are net bearish for L1/L2s dominating market share through incentives for native dApps.

Secondly, blockchain interoperability has been limited to infra and DeFi. But it's consumer apps that will truly unlock 'organic' value transfer across networks.

@bakelandxyz is that killer consumer app. There's nothing more polarizing in crypto than the tribalism embedded deep within L1/L2 ecosystems. So we built an on-chain MMO that unifies chains...by putting them at war! 

  
  ![image](https://github.com/user-attachments/assets/cd3705f6-3f35-41f6-b518-aa9eb93e0916)

  
## Highlighting Use of Wormhole
  1. **Liquidity Balancing Mechanism** across chains using **Wormhole CCQ**
  2. **Real-time access to global data** enables Saturation Factor (SF)
  3. **Unparallelled composability of game assets** - verify ownership of game assets instantly
  

  ![image](https://github.com/user-attachments/assets/ca488a8d-f565-472d-b7bc-2d3e6fb2ffa6)

## Why Wormhole
  1. Saves users time and money (as opposed to cross-chain messaging for high-frequency/low-value data)
  2. Ease of implementation
  3. Security

## Project structure
    ├── contracts                 # smart contracts, FOLLOWING SMART CONTRACTS ARE QUERYRESPONSE CONTRACTS USING WORMHOLE FOR SUBMITTNG QUERY RESPONSE ON CHAIN
    |    └── ERX20s
    |    └── ERC721s
    |    └── Staking
    |       └── facets
    |           └── ChainFacet.sol
    |           └── NftMinter.sol
    |           └── StateUpdate.sol
    ├── scripts                   # scripts for utility functions
    ├── tasks                     # tasks for invoking functions
    ├── wormholeCcq               # service responsible for cross-chain query 
    |   └── handlers              # contains all handlers performing **CCQ** for specfic purpose
    |   └── handler.js            
    |   └── index.js              # file configuring express app
    |   └── server.js             # entrypoint for running server
    ├── LICENSE
    ├── hardhat.config.ts  
    ├── package.json
    ├── README.md
    └── tsconfig.json


## Usage Explanation
1. **Global liquidity reference of $BUDS across 5 networks**
  - Several core functions in our smart contracts require 'global staked $BUDS' for computing fees and rewards.
  - For this, we've used Wormhole CCQ to get 'local staked $BUDS' from all chains and aggregate it to get global liquidity reference on the required network.
  - This ensures our smart contracts compute with the latest global data with the lowest possible latency.
  
Here is a diagram to understand it better - [https://miro.com/app/board/uXjVK6vTceA=/?share_link_id=726924655273]

2. **Cross-Chain PvP Game Escrow**
 - Cross-Chain PvP games are among the most exciting features of Bakeland. This involves a range of games where users from two different chains fight against each other, wagering $BUDS on the outcome.
 The winner of the game takes the sum of wagers.
 - For this, we use CCQ to query the deposit of funds on each chain to start the game and also finalize the game on both chains using atomics swaps.
   
Here is a diagram to understand it better - [https://miro.com/app/board/uXjVK6vTceA=/?share_link_id=726924655273]
    
3. **Composability**
  - Verify asset ownership across multiple chains, saving users time and money otherwise spent on bridging assets.
  - Reward user behavior across multiple networks, even if the network is not actively supported for in-game transactions
  - Create mini-games around live multi-chain data, such as on-chain RTS games. 

## Code snippets of usage
**Query response submission function**
```
    function updateGlobalBudsState(bytes memory response, IWormhole.Signature[] memory signatures) internal {
        uint256 globalCount;
        ParsedQueryResponse memory r = parseAndVerifyQueryResponse(response, signatures);
        uint256 numResponses = r.responses.length;
        if (numResponses != LibGlobalVarState.intStore().noOfChains) {
            revert ("Unmatched length 1");
        }

        for (uint256 i = 0; i < numResponses;) {

            EthCallQueryResponse memory eqr = parseEthCallQueryResponse(r.responses[i]);

            // Validate that update is not stale
            validateBlockTime(eqr.blockTime, block.timestamp - 300);

            if (eqr.result.length != 1) {
                revert ("Unmatched length 2");
            }

            // Validate addresses and function signatures
            address[] memory validAddresses = new address[](1);
            bytes4[] memory validFunctionSignatures = new bytes4[](1);
            validAddresses[0] = address(this);
            validFunctionSignatures[0] = LibGlobalVarState.bytesStore().GetLocalSelector;

            validateMultipleEthCallData(eqr.result, validAddresses, validFunctionSignatures);

            require(eqr.result[0].result.length == 32, "result is not a uint256");

            globalCount += abi.decode(eqr.result[0].result, (uint256));

            unchecked {
                ++i;
            }
        }

        LibGlobalVarState.intStore().globalStakedBudsCount = globalCount;
    }
```

**Above function is utilized to update global reference of liquidty.** That results in latest global liquidty reference of $BUDS used for on-chain computation. For example, In case of users unstaking and claiming their reward tokens the APR percentage should be according to latest global state reference. 
```
    function claimAndUnstake(bytes memory response, IWormhole.Signature[] memory signatures) public {
        uint256 len = LibGlobalVarState.mappingStore().stakeRecord[msg.sender].length;
        if (len == 0) revert LibGlobalVarState.NoStakeFound();

        updateGlobalBudsState(response, signatures);

        uint256 rewards = 0;
        uint256 staked = 0;
        uint256 tokenIdToSend = LibGlobalVarState.mappingStore().stakedFarmer[msg.sender];

        for (uint i = 0; i < len; i++) {
            LibGlobalVarState.Stake memory stk = LibGlobalVarState.mappingStore().stakeRecord[msg.sender][i];
            rewards += calculateStakingReward(stk.budsAmount, stk.timeStamp);
            staked += stk.budsAmount;
            stk.timeStamp = block.timestamp;
        }
        if (LibGlobalVarState.interfaceStore()._stBuds.balanceOf(msg.sender) < staked) revert("Low St Buds");

        LibGlobalVarState.intStore().localStakedBudsCount -= staked;
        LibGlobalVarState.intStore().globalStakedBudsCount -= staked;

        delete LibGlobalVarState.mappingStore().stakeRecord[msg.sender];

        if (tokenIdToSend != 0) {
            LibGlobalVarState.mappingStore().stakedFarmer[msg.sender] = 0;
            LibGlobalVarState.interfaceStore()._farmerToken.safeTransferFrom(address(this), msg.sender, tokenIdToSend);
        }

        bool res = LibGlobalVarState.interfaceStore()._budsToken.transfer(msg.sender, staked);
        LibGlobalVarState.interfaceStore()._stBuds.burnFrom(msg.sender, staked);
        require(res);

        LibGlobalVarState.interfaceStore()._budsVault.sendBudsTo(msg.sender, rewards);

        emit LibGlobalVarState.rewardsClaimed(msg.sender, rewards);
        emit LibGlobalVarState.UnStaked(
            msg.sender,
            tokenIdToSend,
            staked,
            block.timestamp,
            LibGlobalVarState.intStore().localStakedBudsCount,
            LibGlobalVarState.getCurrentApr()
        );
    }
```

**On Off-chain side we use a service to fetch the data and signature receievd from CCQ.**  
  <p align="center" width="100%">
    <img src="https://github.com/user-attachments/assets/25832432-4d1e-4cb1-97e9-3c6bab625484" width=1000 align=center>
  </p>


## Links to services and deployed contract addresses
  service for getting data and sigs form CCQ -  https://24rya9omd6.execute-api.eu-west-3.amazonaws.com/dev/

  Proxy(diamond) contract on all chains - 0xB2A338Fb022365Aa40a2c7ADA3Bbf1Ae001D6dbe 
