import { task } from "hardhat/config";
import { getDeployedAddressesForChain } from "../../../scripts/libraries/getDeployedAddresses";

task("set-st")
.setAction(async (taskArgs, hre) => {
    try{
        const deployedAddresses = await getDeployedAddressesForChain("beraTestnet")

        const contractInst = await hre.ethers.getContractAt("rstBuds", deployedAddresses?.stBuds || "");

        console.log("setting st in rst")

        const tx1 = contractInst.setStBudsContract(deployedAddresses?.stBuds || "",{gasLimit:1500000});

        (await tx1).wait();

        console.log("Done setting RST in st");

    }catch(error){
        console.log("Failed to unstake : ",error)
        throw new Error((<Error>error).message);
    }
    
})