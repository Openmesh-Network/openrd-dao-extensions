import { Deployer } from "../../web3webdeploy/types";
import { Address, DeployInfo } from "../web3webdeploy/types";

export interface TaskDraftsDeploymentSettings
  extends Omit<DeployInfo, "contract" | "args"> {
  tasks: Address;
}

export async function deployTaskDrafts(
  deployer: Deployer,
  settings: TaskDraftsDeploymentSettings
) {
  return await deployer.deploy({
    id: "TaskDrafts",
    contract: "TaskDrafts",
    args: [settings.tasks],
    ...settings,
  });
}
