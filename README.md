# Wormhole Hackathon Submission
  ![image](https://github.com/user-attachments/assets/d9cd7a7c-e54c-40b3-ac68-0ed22613ee4a)

# Bakeland - Unifying chains by putting them at wars
  <p align="center" width="100%">
    <img src="https://github.com/user-attachments/assets/9c172c13-c41f-4a81-8566-55e07a8ea359" width=400 height=400 align=center>
  </p>

Bakeland is game where you can play against your friends across multiple chains. Bakeland is catering two major type of crypto native audiance
  - **Chain Hoppers** - people who hop around the chains for better incentives
  - **Chain loyalist** - People who are are loyal to one chain

Bakeland put these users from different chains in single battleground which has **a unified global state**. Players can do multiple activites and can have multiple roles. Two major roles which determine game mechanics are
  **FARMER** - Staked $BUDS and get boosted staking rewards
  **NARC** - Raids staking pools on any chain
  
User can acquire these roles by getting a FARMER or NARC NFT. Users can do following operations despite :-
  - **Staking** - User can stake in-game native token $BUDS to get staking rewards. One can stake on same chain or other chain as well depending on APR           offered by a chain.
  - **Raiding** - User can raid the staking pools of any chain. Only NARC NFT holders can perform raids. It is probablistic and dependent on a probablistic       success rate derived from various factors. (We have used Supra dVRF for on chain randomness)
  - **Gambling for booster NFTs and extra rewards** - User can burn some amount of $BUDS in return for 50% chance of winning a Booster NFT which will help       to increase staking reward or raid success chances. (We have used Supra dVRF for on chain randomness)
  - **Play PvP minigames** against other players.
  - **bridge tokens and NFTs** from one chain to another chain** in game itself.**
  
## Problem statement 
  92% of crypto native people have **a preffered network. **
  This prefference has **led to tribalism. **
  The sense of **tribalism has led users to keep themselve bound to a single chain.** 
  This **resulted in** **fragmented ecosystems, fragmented liquidity, and fragmented user base.**  

  ![image](https://github.com/user-attachments/assets/cd3705f6-3f35-41f6-b518-aa9eb93e0916)

  
## Solution
  1. **Unified Liquidiy** across the chains using **wormhole CCQ**
  2. **Unified state of assets** across the chains using **wormhole CCQ**
  3. Composibility of game assets
  4. Liquidity balancing game theory
  5. Gamified omni-chain economy

  ![image](https://github.com/user-attachments/assets/ca488a8d-f565-472d-b7bc-2d3e6fb2ffa6)

## Why Wormhole
  1. Speed
  2. Easy to implement
  3. Secure

## Project structure
    ├── contracts                 # Smart contracts
    ├── scripts                   # scripts for utility functions
    ├── tasks                     # tasks for invoking functions
    ├── wormholeCcq               # A service responsible for Cross chain query 
    ├── LICENSE
    ├── hardhat.config.ts  
    ├── package.json
    ├── README.md
    └── tsconfig.json

## Usage Explaination
  1. **Unified global liquidity reference of $BUDS across the chains**
    - Many function in our smart contracts need latest global liquidity data of $BUDS for accurate computation
    - In such functions, we have used wormhole CCQ to get local liquidity data from all chains and aggregate it to get global liquidity reference on             required chain.
    - So the functions will always compute with latest global data and not outdated global data
    - here is a flowchart link to understand it better - miro[https://miro.com/app/board/uXjVK6vTceA=/?share_link_id=726924655273]

  2. **Cross chain PvP game settlement **
    - Cross chain PvP games are one of the most amazing part of bakeland. where users from two different chains fight against each other in a mini-game by       staking $BUDS.
    - Winner of the game takes all
    - As this are cross chain we use CCQ to query submission of funds on each chain to start game and also finalize game on both chains.
    - here is a flowchart link to understand it better - miro[https://miro.com/app/board/uXjVK6vTceA=/?share_link_id=726924655273]
    
  3. **Unified token ID of assets across the chains**
    - Token Ids of cross chain composible assets can collide if a sequential minting took place on each chain
    - Imagine token ID minted on Avax and also minted on bsc
    - If user bridges this asset over to bsc from avax it will be failed as token id 1 is already minted on bsc
    - So, We use wormhole's Cross chain queries to minted tokens across the chains without collision of token Ids.
    - We query latest token Id from all chains and submit this query response to chain where token is being minted.
    - Minter contract decodes the submitted response and checks for highest tokenID which is incremented and a latest token id is minted on chain.
     
  
## Links to services and deployed contract addresses
