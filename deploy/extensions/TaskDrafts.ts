import { Deployer, Address, DeployInfo } from "../../web3webdeploy/types";

export interface DeployTaskDraftsSettings
  extends Omit<DeployInfo, "contract" | "args"> {
  tasks: Address;
}

export async function deployTaskDrafts(
  deployer: Deployer,
  settings: DeployTaskDraftsSettings
) {
  return await deployer.deploy({
    id: "TaskDrafts",
    contract: "TaskDrafts",
    args: [settings.tasks],
    ...settings,
  });
}
