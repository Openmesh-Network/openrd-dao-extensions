// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC165} from "../../lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol";

import {ITaskDisputes, ITasks, IDAOManager, IDAO} from "./ITaskDisputes.sol";

contract TaskDisputes is ERC165, ITaskDisputes {
    mapping(IDAO dao => DaoInfo info) private daoInfo;
    ITasks private immutable tasks;

    constructor(ITasks _tasks) {
        tasks = _tasks;
    }

    /// @inheritdoc ERC165
    function supportsInterface(bytes4 _interfaceId) public view virtual override returns (bool) {
        return _interfaceId == type(ITaskDisputes).interfaceId || super.supportsInterface(_interfaceId);
    }

    /// @inheritdoc ITaskDisputes
    function getGovernancePlugin(IDAO _dao) external view returns (address) {
        return daoInfo[_dao].governancePlugin;
    }

    /// @inheritdoc ITaskDisputes
    function getDisputeCost(IDAO _dao) external view returns (uint256) {
        return daoInfo[_dao].disputeCost;
    }

    /// @inheritdoc ITaskDisputes
    function updateGovernancePlugin(address _governancePlugin) external {
        daoInfo[IDAO(msg.sender)].governancePlugin = _governancePlugin;
    }

    /// @inheritdoc ITaskDisputes
    function updateDisputeCost(uint256 _disputeCost) external {
        daoInfo[IDAO(msg.sender)].disputeCost = _disputeCost;
    }

    /// @inheritdoc ITaskDisputes
    function updateManager(IDAOManager _manager, uint256 _role) external {
        DaoInfo storage info = daoInfo[IDAO(msg.sender)];
        info.manager = _manager;
        info.role = _role;
    }

    /// @inheritdoc ITaskDisputes
    function createDispute(
        IDAO _dao,
        bytes calldata _metadata,
        uint64 _startDate,
        uint64 _endDate,
        DisputeInfo calldata _disputeInfo
    ) external payable {
        DaoInfo memory info = daoInfo[_dao];

        // Dispute cost is required to make a dispute proposal. It is sent to the DAO.
        if (msg.value < info.disputeCost) {
            revert Underpaying();
        }

        // Normal address.transfer does not work with gas estimation
        (bool succes,) = address(_dao).call{value: msg.value}("");
        if (!succes) {
            revert TransferToDAOFailed();
        }

        IDAO.Action[] memory disputeActions = new IDAO.Action[](1);
        {
            bytes memory callData = abi.encodeWithSelector(
                tasks.completeByDispute.selector,
                _disputeInfo.taskId,
                _disputeInfo.partialNativeReward,
                _disputeInfo.partialReward
            );
            disputeActions[0] = IDAO.Action(address(tasks), 0, callData);
        }

        // This only works for DAOs governed with Aragons MajorityVoting
        IDAO.Action[] memory createProposalActions = new IDAO.Action[](1);
        {
            bytes memory callData = abi.encodeWithSignature(
                "createProposal(bytes,(address,uint256,bytes)[],uint256,uint64,uint64,VoteOption,bool)",
                _metadata,
                disputeActions,
                0, // failureMap
                _startDate,
                _endDate,
                0, // voteOption
                false // tryEarlyExecution
            );
            createProposalActions[0] = IDAO.Action(info.governancePlugin, 0, callData);
        }

        (bytes[] memory returnValues,) = info.manager.asDAO(_dao, info.role, createProposalActions, 0);
        (uint256 proposalId) = abi.decode(returnValues[0], (uint256));
        emit DisputeCreated(_dao, _disputeInfo, info.governancePlugin, proposalId);
    }
}
