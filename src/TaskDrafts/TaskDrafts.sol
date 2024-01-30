// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC165} from "../../lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol";

import {ITaskDrafts, ITasks, IDAOManager, IDAO} from "./ITaskDrafts.sol";

contract TaskDrafts is ERC165, ITaskDrafts {
    mapping(IDAO dao => DaoInfo info) private daoInfo;

    /// @inheritdoc ERC165
    function supportsInterface(bytes4 _interfaceId) public view virtual override returns (bool) {
        return _interfaceId == type(ITaskDrafts).interfaceId || super.supportsInterface(_interfaceId);
    }

    /// @inheritdoc ITaskDrafts
    function getGovernancePlugin(IDAO _dao) external view returns (address) {
        return daoInfo[_dao].governancePlugin;
    }

    /// @inheritdoc ITaskDrafts
    function updateGovernancePlugin(address _governancePlugin) external {
        daoInfo[IDAO(msg.sender)].governancePlugin = _governancePlugin;
    }

    /// @inheritdoc ITaskDrafts
    function updateManager(IDAOManager _manager, uint256 _role) external {
        DaoInfo storage info = daoInfo[IDAO(msg.sender)];
        info.manager = _manager;
        info.role = _role;
    }

    /// @inheritdoc ITaskDrafts
    function createDraftTask(
        IDAO _dao,
        bytes calldata _metadata,
        uint64 _startDate,
        uint64 _endDate,
        CreateTaskInfo calldata _taskInfo
    ) external {
        DaoInfo memory info = daoInfo[_dao];

        IDAO.Action[] memory createTaskActions = new IDAO.Action[](1);
        {
            bytes memory callData = abi.encodeWithSelector(
                _taskInfo.tasks.createTask.selector,
                _taskInfo.metadata,
                _taskInfo.deadline,
                _taskInfo.manager,
                _taskInfo.disputeManager,
                _taskInfo.budget,
                _taskInfo.preapproved
            );
            createTaskActions[0] = IDAO.Action(address(_taskInfo.tasks), _taskInfo.nativeBudget, callData);
        }

        // This only works for DAOs governed with Aragons MajorityVoting
        IDAO.Action[] memory createProposalActions = new IDAO.Action[](1);
        {
            bytes memory callData = abi.encodeWithSignature(
                "createProposal(bytes,(address,uint256,bytes)[],uint256,uint64,uint64,VoteOption,bool)",
                _metadata,
                createTaskActions,
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
        emit TaskDraftCreated(_dao, _taskInfo, info.governancePlugin, proposalId);
    }
}
