import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const rate= 2;

const StakeEtherModule = buildModule("stakeEModule", (m) => {
  
  const lock = m.contract("StakeEther",[rate]);

  return { lock };
});

export default StakeEtherModule;
