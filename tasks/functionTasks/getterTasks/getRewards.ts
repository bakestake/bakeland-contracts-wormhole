import { task } from "hardhat/config";
import { getDeployedAddressesForChain } from "../../../scripts/libraries/getDeployedAddresses";
import { bigint } from "hardhat/internal/core/params/argumentTypes";

task("get-reward")
.addParam("chain")
.addParam("address")
.setAction(async (taskArgs, hre) => {
    try{
        const deployedAddresses = await getDeployedAddressesForChain(taskArgs.chain)

        const contractInst = await hre.ethers.getContractAt("GetterSetterFacet", deployedAddresses?.Staking || "");

        console.log("getting rewards for :", taskArgs.address)

        const rewards = await contractInst.getRewardsForUser(taskArgs.address)

        console.log(rewards)

    }catch(error){
        console.log("Failed to unstake : ",error)
        throw new Error((<Error>error).message);
    }
    
})