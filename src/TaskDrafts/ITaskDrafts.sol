// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ITasks} from "../../lib/openrd-foundry/src/ITasks.sol";
import {IDAOManager, IDAO} from "../../lib/trustless-management/src/IDAOManager.sol";

interface ITaskDrafts {
    event TaskDraftCreated(IDAO indexed dao, CreateTaskInfo info, address governancePlugin, uint256 proposalId);

    /// @notice A container for all info related to a certain DAO.
    /// @param governancePlugin The contract where to create the proposals. (Currently this only supports MajorityVoting plugins from Aragon)
    /// @param manager Mangement solution used by the DAO.
    /// @param role Role to use to be allowed to create proposals in the DAO.
    struct DaoInfo {
        address governancePlugin;
        IDAOManager manager;
        uint256 role;
    }

    /// @notice A container for all info needed to create a task.
    /// @param tasks The contract to create the task.
    /// @param metadata The metadata of the created task.
    /// @param deadline The deadline of the created task.
    /// @param manager The manager of the created task.
    /// @param disputeManager The dispute manager of the created task.
    /// @param nativeBudget The native budget of the created task.
    /// @param budget The budget of the created task.
    /// @param preapproved The preapproved applicants of the created task.
    struct CreateTaskInfo {
        string metadata;
        uint64 deadline;
        address manager;
        address disputeManager;
        uint96 nativeBudget;
        ITasks.ERC20Transfer[] budget;
        ITasks.PreapprovedApplication[] preapproved;
    }

    /// @notice The governance plugin where the proposal to accept the dispute can be tracked.
    function getGovernancePlugin(IDAO _dao) external view returns (address);

    /// @notice Updates the governance plugin. The sender should be the DAO that wants to update its governance plugin.
    /// @param _governancePlugin The new governancePlugin.
    function updateGovernancePlugin(address _governancePlugin) external;

    /// @notice Updates the manager and role. The sender should be the DAO that wants to update its manager and role
    /// @param _manager The new manager.
    /// @param _role The new role.
    function updateManager(IDAOManager _manager, uint256 _role) external;

    /// @notice Create a proposal to create a task.
    /// @param _dao The dao to create the proposal to.
    /// @param _metadata The metadata of the proposal.
    /// @param _startDate The start date of the proposal.
    /// @param _endDate The end date of the proposal.
    /// @param _taskInfo The task to be created if the proposal passes.
    /// @dev Does not approve the budget for spending. The DAO should approve the budget in advance (select ERC20s can have a high allowance set)
    function createDraftTask(
        IDAO _dao,
        bytes calldata _metadata,
        uint64 _startDate,
        uint64 _endDate,
        CreateTaskInfo calldata _taskInfo
    ) external;
}
