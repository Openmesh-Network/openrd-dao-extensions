import { Deployer } from "../../web3webdeploy/types";
import { Address, DeployInfo } from "../web3webdeploy/types";

export interface TaskDisputesDeploymentSettings
  extends Omit<DeployInfo, "contract" | "args"> {
  tasks: Address;
}

export async function deployTaskDisputes(
  deployer: Deployer,
  settings: TaskDisputesDeploymentSettings
) {
  return await deployer.deploy({
    id: "TaskDisputes",
    contract: "TaskDisputes",
    args: [settings.tasks],
    ...settings,
  });
}
