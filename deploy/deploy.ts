import { zeroAddress } from "viem";
import { Address, Deployer } from "../web3webdeploy/types";

export interface DeploymentSettings {
  tasks: Address;
}

export interface Deployment {
  taskDisputes: Address;
  taskDrafts: Address;
}

export async function deploy(
  deployer: Deployer,
  settings?: DeploymentSettings
): Promise<Deployment> {
  const taskDisputes = await deployer.deploy({
    id: "TaskDisputes",
    contract: "TaskDisputes",
    args: [settings?.tasks ?? zeroAddress],
  });
  const taskDrafts = await deployer.deploy({
    id: "TaskDrafts",
    contract: "TaskDrafts",
    args: [settings?.tasks ?? zeroAddress],
  });
  return {
    taskDisputes: taskDisputes,
    taskDrafts: taskDrafts,
  };
}
