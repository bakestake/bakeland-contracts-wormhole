import { task } from "hardhat/config";
import { getDeployedAddressesForChain } from "../../../scripts/libraries/getDeployedAddresses";

task("cc-stake-bera")
.setAction(async (taskArgs, hre) => {
    try{
        const deployedAddresses = await getDeployedAddressesForChain("beraTestnet")

        const contractInst = await hre.ethers.getContractAt("StBuds", deployedAddresses?.stBuds || "");

        console.log("approving")
        const tx = await contractInst.approve(deployedAddresses?.stBuds||"","100000000000000000000",{gasLimit:2500000});
        await tx.wait();

        console.log("sending cc")
        const tx1 = await contractInst.crossChainBeraStake("100000000000000000000",{gasLimit:2500000, value:hre.ethers.parseEther("0.01")});
        await tx1.wait();

        console.log("Done sending cc");

    }catch(error){
        console.log("Failed to send cc : ",error)
        throw new Error((<Error>error).message);
    }
    
})