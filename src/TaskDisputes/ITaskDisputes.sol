// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ITasks} from "../../lib/openrd-foundry/src/ITasks.sol";
import {IDAOManager, IDAO} from "../../lib/trustless-management/src/IDAOManager.sol";

interface ITaskDisputes {
    error Underpaying();
    error TransferToDAOFailed();

    event DisputeCreated(IDAO indexed _dao, DisputeInfo dispute, address governancePlugin, uint256 proposalId);

    /// @notice A container for all info related to a certain DAO.
    /// @param disputeCost How much native currency should be paid to be allowed to create a dispute in this DAO.
    /// @param governancePlugin The contract where to create the proposals. (Currently this only supports MajorityVoting plugins from Aragon)
    /// @param manager Mangement solution used by the DAO.
    /// @param role Role to use to be allowed to create proposals in the DAO.
    struct DaoInfo {
        uint256 disputeCost;
        address governancePlugin;
        IDAOManager manager;
        uint256 role;
    }

    /// @notice A container for all info needed to make an task dispute.
    /// @param tasks The contract containing the task.
    /// @param taskId The task wanting to complete by dispute.
    /// @param partialNativeReward Complete with how much of the native reward.
    /// @param partialReward Complete with how much of the reward.
    struct DisputeInfo {
        ITasks tasks;
        uint256 taskId;
        uint96[] partialNativeReward;
        uint88[] partialReward;
    }

    /// @notice The governance plugin where the proposal to accept the dispute can be tracked.
    function getGovernancePlugin(IDAO _dao) external view returns (address);

    /// @notice The minimum amount of native currency that has to be attached to create a dispute.
    function getDisputeCost(IDAO _dao) external view returns (uint256);

    /// @notice Updates the governance plugin. The sender should be the DAO that wants to update its governance plugin.
    /// @param _governancePlugin The new governancePlugin.
    function updateGovernancePlugin(address _governancePlugin) external;

    /// @notice Updates the dispute cost. The sender should be the DAO that wants to update its dispute cost.
    /// @param _disputeCost The new dispute cost.
    function updateDisputeCost(uint256 _disputeCost) external;

    /// @notice Updates the manager and role. The sender should be the DAO that wants to update its manager and role
    /// @param _manager The new manager.
    /// @param _role The new role.
    function updateManager(IDAOManager _manager, uint256 _role) external;

    /// @notice Create a dispute for a task
    /// @param _dao The dao requested for the dispute.
    /// @param _metadata Metadata of the proposal.
    /// @param _startDate Start date of the proposal.
    /// @param _endDate End date of the proposal.
    /// @param _disputeInfo The proposed dispute.
    function createDispute(
        IDAO _dao,
        bytes calldata _metadata,
        uint64 _startDate,
        uint64 _endDate,
        DisputeInfo calldata _disputeInfo
    ) external payable;
}
