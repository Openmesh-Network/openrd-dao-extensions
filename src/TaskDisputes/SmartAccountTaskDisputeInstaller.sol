// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {
    SmartAccountPaidActionInstaller,
    ISmartAccountTrustlessExecution,
    ITrustlessManagement,
    ITrustlessActions,
    IPaidAction
} from "../../lib/trustless-actions/src/smart-account-installers/SmartAccountPaidActionInstaller.sol";

import {ITasks} from "../../lib/openrd-foundry/src/ITasks.sol";

contract SmartAccountTaskDisputeInstaller is SmartAccountPaidActionInstaller {
    ITasks public immutable tasks;

    constructor(
        ISmartAccountTrustlessExecution _smartAccountTrustlessExecution,
        ITrustlessManagement _addressTrustlessManagement,
        ITrustlessActions _trustlessActions,
        IPaidAction _taskDisputes,
        ITasks _tasks
    )
        SmartAccountPaidActionInstaller(
            _smartAccountTrustlessExecution,
            _addressTrustlessManagement,
            _trustlessActions,
            _taskDisputes
        )
    {
        tasks = _tasks;
    }

    function grantPermissions() internal override {
        grantFunctionAccess(address(tasks), tasks.completeByDispute.selector);
    }

    function revokePermissions() internal override {
        revokeFunctionAccess(address(tasks), tasks.completeByDispute.selector);
    }
}
