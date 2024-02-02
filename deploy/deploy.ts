import { Address, Deployer } from "../web3webdeploy/types";
import {
  TasksDeployment,
  deploy as tasksDeploy,
} from "../lib/openrd-foundry/deploy/deploy";
import {
  TaskDisputesDeploymentSettings,
  deployTaskDisputes,
} from "./TaskDisputes";
import { TaskDraftsDeploymentSettings, deployTaskDrafts } from "./TaskDrafts";

export interface DeploymentSettings {
  tasksDeployment: TasksDeployment;
  taskDisputeDeploymentSettings: Omit<TaskDisputesDeploymentSettings, "tasks">;
  taskDraftsDeploymentSettings: Omit<TaskDraftsDeploymentSettings, "tasks">;
}

export interface Deployment {
  taskDisputes: Address;
  taskDrafts: Address;
}

export async function deploy(
  deployer: Deployer,
  settings?: DeploymentSettings
): Promise<Deployment> {
  deployer.startContext("lib/openrd-foundry");
  const tasksDeployment =
    settings?.tasksDeployment ?? (await tasksDeploy(deployer));
  deployer.finishContext();

  const taskDisputes = await deployTaskDisputes(deployer, {
    ...(settings?.taskDisputeDeploymentSettings ?? {}),
    tasks: tasksDeployment.tasks,
  });

  const taskDrafts = await deployTaskDrafts(deployer, {
    ...(settings?.taskDraftsDeploymentSettings ?? {}),
    tasks: tasksDeployment.tasks,
  });

  return {
    taskDisputes: taskDisputes,
    taskDrafts: taskDrafts,
  };
}
