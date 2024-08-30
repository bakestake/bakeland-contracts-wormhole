import { task } from "hardhat/config";
import { getDeployedAddressesForChain } from "../../scripts/libraries/getDeployedAddresses";

task("mint-farmer")
.addParam("chain")
.setAction(async (taskArgs, hre) => {
    try{
        const deployedAddresses = await getDeployedAddressesForChain(taskArgs.chain)

        const contractInst = await hre.ethers.getContractAt("NFTFaucet", deployedAddresses?.NFTFaucet || "");

        console.log("Minting")

        await contractInst.claimFarmer();

        console.log("Minted")


    }catch(error){
        console.log("Failed to mint farmer : ",error)
        throw new Error((<Error>error).message);
    }
    
})