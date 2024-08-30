import { task } from "hardhat/config";
import { getDeployedAddressesForChain } from "../../../scripts/libraries/getDeployedAddresses";

task("read-st-store")
.setAction(async (taskArgs, hre) => {
    try{
        const deployedAddresses = await getDeployedAddressesForChain("beraTestnet")

        const bytecode = "60523d8160223d3973ab1e4823c73a0e1dd81539b2972a4e9140328b6d60195155f3363d3d373d3d363d602036600436635c60da1b60e01b36527fa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50545afa5036515af43d6000803e604d573d6000fd5b3d6000f3"
        
        const contractInst = await hre.ethers.getContractAt("StBuds", deployedAddresses?.stBuds || "");

        console.log("staking in bera gauge")

        const tx1 = await contractInst._beraGauge()

        const tx2 = await contractInst._rstBuds();

        const tx3 = await contractInst.beraEndpoint();

        const tx4 = await contractInst._stakingContract();

        console.log("gauge address : ", tx1);
        console.log("rst address : ", tx2);
        console.log("bera endpoint address : ", tx3);
        console.log("staking address : ", tx4);

    }catch(error){
        console.log("Failed to unstake : ",error)
        throw new Error((<Error>error).message);
    }
    
})