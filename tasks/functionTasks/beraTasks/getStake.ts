import { task } from "hardhat/config";
import { getDeployedAddressesForChain } from "../../../scripts/libraries/getDeployedAddresses";

task("get-bera-stake")
.addParam("address")
.setAction(async (taskArgs, hre) => {
    try{
        const deployedAddresses = await getDeployedAddressesForChain("beraTestnet")

        const contractInst = await hre.ethers.getContractAt("IGauge", "0x8d7e98e3e447f12bda3d4efc97acbe278a969e0b");

        console.log("getting whitelist in bera gauge")

        const tx = await contractInst.balanceOf(taskArgs.address);

        console.log("tx hash", tx);

    }catch(error){
        console.log("Failed to unstake : ",error)
        throw new Error((<Error>error).message);
    }
    
})