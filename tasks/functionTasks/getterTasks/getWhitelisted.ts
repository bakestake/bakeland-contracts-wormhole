import { task } from "hardhat/config";
import { getDeployedAddressesForChain } from "../../../scripts/libraries/getDeployedAddresses";

task("get-gauge-list")
.setAction(async (taskArgs, hre) => {
    try{
        const deployedAddresses = await getDeployedAddressesForChain("beraTestnet")

        const contractInst = await hre.ethers.getContractAt("IGauge", "0x8d7E98e3E447F12BDA3D4Efc97acBE278a969e0B");

        console.log("getting whitelist in bera gauge")

        const list = await contractInst.getTotalDelegateStaked("0x55CC1e9b2CB571957b1F6Cd0972543d7Af00d72e");

        console.log(list)

    }catch(error){
        console.log("Failed to unstake : ",error)
        throw new Error((<Error>error).message);
    }
    
})