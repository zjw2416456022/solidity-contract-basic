// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20; 

contract BeggingContract {
    address public immutable owner;
    mapping(address => uint256) public donations; // 记录每个捐赠者的总捐赠金额
    uint256 public totalDonations; // 合约累计总捐赠额
    address[] public donors; // 存储所有捐赠过的地址（用于排行榜遍历）
    
    // ============ 时间限制相关变量（额外挑战3） ============
    uint256 public donateStartTime; // 捐赠开始时间戳（秒）
    uint256 public donateEndTime; // 捐赠结束时间戳（秒）

    // ============ 事件定义（额外挑战1） ============
    /// @notice 记录每次捐赠的信息
    event DonationReceived(address indexed donor, uint256 amount, uint256 timestamp);
    /// @notice 记录所有者提取资金的信息
    event FundsWithdrawn(address indexed owner, uint256 amount, uint256 timestamp);

   
    modifier onlyOwner() {
        require(msg.sender == owner, "BeggingContract: only owner can execute");
        _;
    }

    // ============ 时间限制修饰符（额外挑战3） ============
    /// @notice 仅在指定捐赠时间段内可调用
    modifier onlyDuringDonationPeriod() {
        require(
            block.timestamp >= donateStartTime && block.timestamp <= donateEndTime,
            "BeggingContract: donation is not allowed at this time"
        );
        _;
    }

    constructor(uint256 _startTime, uint256 _endTime) {
        owner = msg.sender;
        donateStartTime = _startTime;
        donateEndTime = _endTime;
    }

    // ============ 捐赠ETH ============
    /// @notice 向合约捐赠ETH，仅在指定时间段内可调用
    function donate() public payable onlyDuringDonationPeriod {
        // 校验捐赠金额必须大于0
        require(msg.value > 0, "BeggingContract: donation amount must be > 0");
        
        // 更新捐赠记录：首次捐赠则添加到donors数组
        if (donations[msg.sender] == 0) {
            donors.push(msg.sender);
        }
        donations[msg.sender] += msg.value;
        totalDonations += msg.value;

        // 发射捐赠事件（方便链上追踪/前端展示）
        emit DonationReceived(msg.sender, msg.value, block.timestamp);
    }

    // ============ 所有者提取所有资金 ============
    /// @notice 合约所有者提取合约内所有ETH
    function withdraw() public onlyOwner {
        uint256 contractBalance = address(this).balance;
        // 校验合约内有可提取的资金
        require(contractBalance > 0, "BeggingContract: no funds to withdraw");
        
        // 向所有者转移资金
        payable(owner).transfer(contractBalance);

        // 发射提款事件
        emit FundsWithdrawn(owner, contractBalance, block.timestamp);
    }

    // ============ 查询指定地址捐赠额 ============
    /// @notice 查询某个地址的累计捐赠金额
    /// @param donor 捐赠者地址
    /// @return 该地址的累计捐赠额（wei）
    function getDonation(address donor) public view returns (uint256) {
        return donations[donor];
    }

    // ============ 额外挑战2：捐赠排行榜（前3） ============
    /// @notice 获取捐赠金额最多的前3个地址及对应金额
    /// @return topAddresses 前3捐赠者地址数组
    /// @return topAmounts 前3捐赠者金额数组（wei）
    function getTop3Donors() public view returns (address[3] memory topAddresses, uint256[3] memory topAmounts) {
        // 初始化前3名（默认值为0地址和0金额）
        topAddresses = [address(0), address(0), address(0)];
        topAmounts = [uint256(0), uint256(0), uint256(0)];

        // 遍历所有捐赠者，筛选前3名
        for (uint256 i = 0; i < donors.length; i++) {
            address currentDonor = donors[i];
            uint256 currentAmount = donations[currentDonor];

            // 对比并更新第三名
            if (currentAmount > topAmounts[2]) {
                topAmounts[2] = currentAmount;
                topAddresses[2] = currentDonor;
            }
            // 对比并更新第二名
            if (topAmounts[2] > topAmounts[1]) {
                (topAmounts[1], topAmounts[2]) = (topAmounts[2], topAmounts[1]);
                (topAddresses[1], topAddresses[2]) = (topAddresses[2], topAddresses[1]);
            }
            // 对比并更新第一名
            if (topAmounts[1] > topAmounts[0]) {
                (topAmounts[0], topAmounts[1]) = (topAmounts[1], topAmounts[0]);
                (topAddresses[0], topAddresses[1]) = (topAddresses[1], topAddresses[0]);
            }
        }

        return (topAddresses, topAmounts);
    }

 
}