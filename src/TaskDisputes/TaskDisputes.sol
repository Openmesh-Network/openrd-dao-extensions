// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {CreateTrustlessAction} from "../../lib/trustless-actions/src/extensions/CreateTrustlessAction.sol";
import {PaidAction} from "../../lib/trustless-actions/src/extensions/PaidAction.sol";
import {OpenmeshENSReverseClaimable} from "../../lib/openmesh-admin/src/OpenmeshENSReverseClaimable.sol";

import {ITasks} from "../../lib/openrd-foundry/src/ITasks.sol";
import {ITaskDisputes, IDAO} from "./ITaskDisputes.sol";

contract TaskDisputes is CreateTrustlessAction, PaidAction, OpenmeshENSReverseClaimable, ITaskDisputes {
    ITasks public immutable tasks;

    constructor(ITasks _tasks) {
        tasks = _tasks;
    }

    /// @inheritdoc PaidAction
    function supportsInterface(bytes4 _interfaceId) public view virtual override returns (bool) {
        return _interfaceId == type(ITaskDisputes).interfaceId || super.supportsInterface(_interfaceId);
    }

    /// @inheritdoc ITaskDisputes
    function createDispute(
        IDAO _dao,
        string calldata _metadata,
        ManagementInfo calldata _managementInfo,
        TrustlessActionsInfo calldata _trustlessActionsInfo,
        DisputeInfo calldata _disputeInfo
    ) external payable {
        _ensurePaid(_dao);

        IDAO.Action[] memory actions = new IDAO.Action[](1);
        actions[0] = IDAO.Action(
            address(tasks),
            0,
            abi.encodeWithSelector(
                tasks.completeByDispute.selector,
                _disputeInfo.taskId,
                _disputeInfo.partialNativeReward,
                _disputeInfo.partialReward
            )
        );

        _createAction(_dao, _metadata, _managementInfo, _trustlessActionsInfo, actions);
    }
}
