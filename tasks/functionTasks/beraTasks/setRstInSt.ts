import { task } from "hardhat/config";
import { getDeployedAddressesForChain } from "../../../scripts/libraries/getDeployedAddresses";

task("set-Rst")
.setAction(async (taskArgs, hre) => {
    try{
        const deployedAddresses = await getDeployedAddressesForChain("beraTestnet")

        const contractInst = await hre.ethers.getContractAt("StBuds", deployedAddresses?.stBuds || "");

        console.log("staking in bera gauge")

        const tx1 = contractInst.setRstBuds(deployedAddresses?.rstBuds || "",{gasLimit:1500000});

        (await tx1).wait();

        console.log("Done setting RST in st");

    }catch(error){
        console.log("Failed to unstake : ",error)
        throw new Error((<Error>error).message);
    }
    
})