// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {
    SmartAccountPaidActionInstaller,
    ISmartAccountTrustlessExecution,
    ITrustlessManagement,
    ITrustlessActions,
    IPaidAction
} from "../../lib/trustless-actions/src/smart-account-installers/SmartAccountPaidActionInstaller.sol";

import {ITasks} from "../../lib/openrd/src/ITasks.sol";

contract SmartAccountTaskDraftsInstaller is SmartAccountPaidActionInstaller {
    ITasks public immutable tasks;

    constructor(
        ISmartAccountTrustlessExecution _smartAccountTrustlessExecution,
        ITrustlessManagement _addressTrustlessManagement,
        ITrustlessActions _trustlessActions,
        IPaidAction _taskDrafts,
        ITasks _tasks
    )
        SmartAccountPaidActionInstaller(
            _smartAccountTrustlessExecution,
            _addressTrustlessManagement,
            _trustlessActions,
            _taskDrafts
        )
    {
        tasks = _tasks;
    }

    function grantPermissions() internal override {
        grantFunctionAccess(address(tasks), tasks.createTask.selector);
    }

    function revokePermissions() internal override {
        revokeFunctionAccess(address(tasks), tasks.createTask.selector);
    }
}
