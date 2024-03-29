// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ICreateTrustlessAction, IDAO} from "../../lib/trustless-actions/src/extensions/ICreateTrustlessAction.sol";

interface ITaskDisputes {
    /// @notice A container for all info needed to make an task dispute.
    /// @param taskId The task wanting to complete by dispute.
    /// @param partialNativeReward Complete with how much of the native reward.
    /// @param partialReward Complete with how much of the reward.
    struct DisputeInfo {
        uint256 taskId;
        uint96[] partialNativeReward;
        uint88[] partialReward;
    }

    /// @notice Create a dispute for a task.
    /// @param _dao The dao requested to resolve the dispute.
    /// @param _metadata Metadata of the proposal.
    /// @param _managementInfo The information related to creating the action.
    /// @param _trustlessActionsInfo The infromation related to executing the action.
    /// @param _disputeInfo The proposed dispute.
    function createDispute(
        IDAO _dao,
        string calldata _metadata,
        ICreateTrustlessAction.ManagementInfo calldata _managementInfo,
        ICreateTrustlessAction.TrustlessActionsInfo calldata _trustlessActionsInfo,
        DisputeInfo calldata _disputeInfo
    ) external payable;
}
