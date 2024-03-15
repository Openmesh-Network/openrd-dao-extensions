import { Deployer, Address, DeployInfo } from "../../web3webdeploy/types";

export interface DeployTaskDisputesSettings
  extends Omit<DeployInfo, "contract" | "args"> {
  tasks: Address;
}

export async function deployTaskDisputes(
  deployer: Deployer,
  settings: DeployTaskDisputesSettings
) {
  return await deployer.deploy({
    id: "TaskDisputes",
    contract: "TaskDisputes",
    args: [settings.tasks],
    ...settings,
  });
}
