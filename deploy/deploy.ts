import { zeroAddress } from "viem";
import { Address, Deployer } from "../web3webdeploy/types";
import { deploy as openmeshAdminDeploy } from "../lib/openmesh-admin/deploy/deploy";
import { deploy as ensReverseRegistrarDeploy } from "../lib/ens-reverse-registrar/deploy/deploy";
import { deploy as tasksDeploy } from "../lib/openrd-foundry/deploy/deploy";

export interface DeploymentSettings {
  tasks?: Address;
  admin?: Address;
  ensReverseRegistar?: Address;
}

export interface Deployment {
  taskDisputes: Address;
  taskDrafts: Address;
}

export async function deploy(
  deployer: Deployer,
  settings?: DeploymentSettings
): Promise<Deployment> {
  deployer.startContext("lib/openmesh-admin");
  const admin = settings?.admin ?? (await openmeshAdminDeploy(deployer)).admin;
  deployer.finishContext();

  deployer.startContext("lib/ens-reverse-registrar");
  const ensReverseRegistrar =
    settings?.ensReverseRegistar ??
    (await ensReverseRegistrarDeploy(deployer)).reverseRegistrar;
  deployer.finishContext();

  deployer.startContext("lib/openrd-foundry");
  const tasks =
    settings?.tasks ??
    (await tasksDeploy(deployer, { admin, ensReverseRegistrar })).tasks;
  deployer.finishContext();

  const taskDisputes = await deployer.deploy({
    id: "TaskDisputes",
    contract: "TaskDisputes",
    args: [tasks, admin, ensReverseRegistrar],
  });

  const taskDrafts = await deployer.deploy({
    id: "TaskDrafts",
    contract: "TaskDrafts",
    args: [tasks, admin, ensReverseRegistrar],
  });

  return {
    taskDisputes: taskDisputes,
    taskDrafts: taskDrafts,
  };
}
