import { task } from "hardhat/config";
import { getDeployedAddressesForChain } from "../../../scripts/libraries/getDeployedAddresses";
import { getConstants } from "../../../scripts/libraries/getConstants";

task("set-bera-fren")
.addParam("chain")
.setAction(async (taskArgs, hre) => {
    try{
        if(taskArgs.chain == "beraTestnet"){

            const chains = ["amoy", "fuji", "bscTestnet", "arbSepolia", "baseSepolia"]
            const deployedAddresses = await getDeployedAddressesForChain("beraTestnet")
            const contractInst = await hre.ethers.getContractAt("StBuds", deployedAddresses?.stBuds || "");

            for(let i = 0; i < chains.length; i++){
                const targetConst = await getConstants(chains[i]);
                const targetAddress = await getDeployedAddressesForChain(chains[i])
                await contractInst.setPeer(targetConst?.endpointId || "", hre.ethers.zeroPadValue(targetAddress?.stBuds || "", 32), {gasLimit:2500000});
            }

        }else{
            const deployedAddresses = await getDeployedAddressesForChain("beraTestnet")
            const beraConst = await getConstants("beraTestnet");

            const contractInst = await hre.ethers.getContractAt("StBuds", deployedAddresses?.stBuds || "");

            await contractInst.setPeer(beraConst?.endpointId || "", hre.ethers.zeroPadValue(deployedAddresses?.stBuds || "", 32), {gasLimit:2500000});
        }
        


    }catch(error){
        console.log("Failed to set frens : ",error)
        throw new Error((<Error>error).message);
    }
    
})