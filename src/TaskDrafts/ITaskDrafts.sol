// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ITasks} from "../../lib/openrd-foundry/src/ITasks.sol";
import {ICreateTrustlessAction, IDAO} from "../../lib/trustless-actions/src/extensions/ICreateTrustlessAction.sol";

interface ITaskDrafts {
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

    /// @notice Create a proposal to create a task.
    /// @param _dao The dao requested to create the task.
    /// @param _metadata Metadata of the proposal.
    /// @param _managementInfo The information related to creating the action.
    /// @param _trustlessActionsInfo The information related to executing the action.
    /// @param _taskInfo The task to be created if the proposal passes.
    /// @dev Does not approve the budget for spending. The DAO should approve the budget in advance (select ERC20s can have a high allowance set)
    function createDraftTask(
        IDAO _dao,
        string calldata _metadata,
        ICreateTrustlessAction.ManagementInfo calldata _managementInfo,
        ICreateTrustlessAction.TrustlessActionsInfo calldata _trustlessActionsInfo,
        CreateTaskInfo calldata _taskInfo
    ) external;
}
