// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {CreateTrustlessAction} from "../../lib/trustless-actions/src/extensions/CreateTrustlessAction.sol";
import {PaidAction} from "../../lib/trustless-actions/src/extensions/PaidAction.sol";
import {OpenmeshENSReverseClaimable} from "../../lib/openmesh-admin/src/OpenmeshENSReverseClaimable.sol";

import {ITaskDrafts, ITasks, IDAO} from "./ITaskDrafts.sol";

contract TaskDrafts is CreateTrustlessAction, PaidAction, OpenmeshENSReverseClaimable, ITaskDrafts {
    ITasks private immutable tasks;

    constructor(ITasks _tasks) {
        tasks = _tasks;
    }

    /// @inheritdoc PaidAction
    function supportsInterface(bytes4 _interfaceId) public view virtual override returns (bool) {
        return _interfaceId == type(ITaskDrafts).interfaceId || super.supportsInterface(_interfaceId);
    }

    /// @inheritdoc ITaskDrafts
    function createDraftTask(
        IDAO _dao,
        string calldata _metadata,
        ManagementInfo calldata _managementInfo,
        TrustlessActionsInfo calldata _trustlessActionsInfo,
        CreateTaskInfo calldata _taskInfo
    ) external {
        _ensurePaid(_dao);

        IDAO.Action[] memory actions = new IDAO.Action[](1);
        actions[0] = IDAO.Action(
            address(tasks),
            _taskInfo.nativeBudget,
            abi.encodeWithSelector(
                tasks.createTask.selector,
                _taskInfo.metadata,
                _taskInfo.deadline,
                _taskInfo.manager,
                _taskInfo.disputeManager,
                _taskInfo.budget,
                _taskInfo.preapproved
            )
        );

        _createAction(_dao, _metadata, _managementInfo, _trustlessActionsInfo, actions);
    }
}
