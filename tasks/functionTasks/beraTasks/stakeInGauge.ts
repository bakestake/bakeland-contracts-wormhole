import { task } from "hardhat/config";
import { getDeployedAddressesForChain } from "../../../scripts/libraries/getDeployedAddresses";

task("stake-gauge")
.addParam("amount")
.setAction(async (taskArgs, hre) => {
    try{
        const deployedAddresses = await getDeployedAddressesForChain("beraTestnet")

        const contractInst = await hre.ethers.getContractAt("StBuds", deployedAddresses?.stBuds || "");

        console.log("Approving gauge contract to spend stBuds");

        const tx1 = await contractInst.approve(deployedAddresses?.stBuds || "", hre.ethers.parseEther(taskArgs.amount));

        await tx1.wait();

        const tx2 = await contractInst.approve("0x8d7e98e3e447f12bda3d4efc97acbe278a969e0b", hre.ethers.parseEther(taskArgs.amount));

        await tx2.wait();

        console.log("staking in bera gauge")

        console.log(hre.ethers.parseEther(taskArgs.amount))

        const tx = await contractInst.stakeInBeraGauge( hre.ethers.parseEther(taskArgs.amount),{gasLimit:3500000});

        await tx.wait();

        console.log("tx hash:",await tx.hash)

        console.log("staked in gauge:", taskArgs.amount)

    }catch(error){
        console.log("Failed to stake : ",error)
        throw new Error((<Error>error).message);
    }
    
})