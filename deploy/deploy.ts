import { Address, Deployer } from "../web3webdeploy/types";
import {
  TasksDeployment,
  deploy as tasksDeploy,
} from "../lib/openrd/deploy/deploy";
import {
  DeployTaskDisputesSettings,
  deployTaskDisputes,
} from "./internal/TaskDisputes";
import {
  DeployTaskDraftsSettings,
  deployTaskDrafts,
} from "./internal/TaskDrafts";

export interface OpenRDDaoExtensionsDeploymentSettings {
  tasksDeployment: TasksDeployment;
  taskDisputeDeploymentSettings: Omit<DeployTaskDisputesSettings, "tasks">;
  taskDraftsDeploymentSettings: Omit<DeployTaskDraftsSettings, "tasks">;
  forceRedeploy?: boolean;
}

export interface OpenRDDaoExtensionsDeployment {
  taskDisputes: Address;
  taskDrafts: Address;
}

export async function deploy(
  deployer: Deployer,
  settings?: OpenRDDaoExtensionsDeploymentSettings
): Promise<OpenRDDaoExtensionsDeployment> {
  if (settings?.forceRedeploy !== undefined && !settings.forceRedeploy) {
    const existingDeployment = await deployer.loadDeployment({
      deploymentName: "latest.json",
    });
    if (existingDeployment !== undefined) {
      return existingDeployment;
    }
  }

  deployer.startContext("lib/openrd-foundry");
  const tasksDeployment =
    settings?.tasksDeployment ?? (await tasksDeploy(deployer));
  deployer.finishContext();

  const taskDisputes = await deployTaskDisputes(deployer, {
    tasks: tasksDeployment.tasks,
    ...(settings?.taskDisputeDeploymentSettings ?? {}),
  });

  const taskDrafts = await deployTaskDrafts(deployer, {
    tasks: tasksDeployment.tasks,
    ...(settings?.taskDraftsDeploymentSettings ?? {}),
  });

  const deployment: OpenRDDaoExtensionsDeployment = {
    taskDisputes: taskDisputes,
    taskDrafts: taskDrafts,
  };
  await deployer.saveDeployment({
    deploymentName: "latest.json",
    deployment: deployment,
  });
  return deployment;
}
