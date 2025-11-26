// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
    创建一个名为Voting的合约，包含以下功能：
    一个mapping来存储候选人的得票数
    一个vote函数，允许用户投票给某个候选人
    一个getVotes函数，返回某个候选人的得票数
    一个resetVotes函数，重置所有候选人的得票数
 */

/**
 * @title Voting
 * @dev 投票合约
 */
contract Voting is Ownable, ReentrancyGuard  {
    // 候选人地址 -> 得票数
    mapping(address => uint256) private _candidateVotes;
    
    // 候选人是否存在
    mapping(address => bool) private _isRegisteredCandidate;
    
    // 候选人列表
    address[] private _registeredCandidates;

    event CandidateRegistered(address indexed candidate); // 候选人注册事件
    event Voted(address indexed voter, address indexed candidate, uint256 newVoteCount); // 投票事件
    event VotesReset(uint256 resetTimestamp); // 投票重置事件

    /**
     * @param initialOwner 合约初始所有者地址（通常为部署者）
     */
    constructor(address initialOwner) Ownable(initialOwner) {
        // 校验初始所有者地址有效（避免传入 address(0)）
        require(initialOwner != address(0), "Voting: initial owner is zero address");
    }

    /// 候选人注册，仅合约所有者可添加候选人
    /// @param candidate 候选人地址（非0地址）
    function addCandidate(address candidate) external onlyOwner  {
        // 双重校验：地址有效 + 未重复注册
        require(candidate != address(0), "Voting: invalid candidate address");
        require(!_isRegisteredCandidate[candidate], "Voting: candidate already registered");

        // 标记为已注册 + 加入列表
        _isRegisteredCandidate[candidate] = true;
        _registeredCandidates.push(candidate);

        emit CandidateRegistered(candidate); // 触发事件，方便链下追踪
    }

    /// 允许用户投票给某个候选人
    /// @param candidate 候选人地址
    function vote(address candidate) external nonReentrant {
        // 候选人是否存在
        require(_isRegisteredCandidate[candidate], "Voting: candidate not registered");

        // 得票数 +1
        _candidateVotes[candidate]++;

        // 触发事件，记录投票行为（链下可通过事件统计投票记录）
        emit Voted(msg.sender, candidate, _candidateVotes[candidate]);
    }

    /// 返回某个候选人的得票数
    function getVotes(address candidate) external view returns (uint256) {
        return _candidateVotes[candidate];
    }

    /// 重置所有候选人的得票数，仅所有者可重置所有候选人得票数
    function resetVotes() external onlyOwner nonReentrant {
        for (uint256 i = 0; i < _registeredCandidates.length; i++) {
            address candidate = _registeredCandidates[i];
            _candidateVotes[candidate] = 0;
        }
        emit VotesReset(block.timestamp); // 触发重置事件，留痕可追溯
    }
}