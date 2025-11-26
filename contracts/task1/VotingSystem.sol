// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract VotingSystem {
    //1. 定义枚举
    enum Vote {
        Yes,
        No,
        Abstain
    }
    //2. 状态变量
    mapping(address => Vote) public votes;
    mapping(address => bool) public hasVoted;
    uint public yesCount;
    uint public noCount;
    uint public abstainCount;

    event Voted(address indexed voter, Vote vote);


    //3. 投票函数
    function vote(Vote _vote) public {
        // TODO:实现投票逻辑
        // - 检查是否已投票
        // - 记录投票
        // - 更新票数
        require(!hasVoted[msg.sender], "Already voted");
        votes[msg.sender] = _vote;
        hasVoted[msg.sender] = true;
        if (_vote == Vote.Yes) {
            yesCount++;
        } else if (_vote == Vote.No) {
            noCount++;
        } else {
            abstainCount++;
        }
        emit Voted(msg.sender, _vote);
    }

    //4. 查询函数
    function getResults() public view returns (uint, uint, uint) {
        return (yesCount, noCount, abstainCount);
    }

    function getMyVote() public view returns (Vote) {
        require(hasVoted[msg.sender], "You haven't voted");
        return votes[msg.sender];
    }
}
