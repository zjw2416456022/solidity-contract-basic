// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * 简单的 ERC20 代币合约
 */
contract SimpleERC20 {
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;

    // 存储每个地址的代币余额
    mapping(address => uint256) public balanceOf;
    // 存储授权信息: owner -> spender -> 授权额度
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    address public owner;

    /**
     * @dev 构造函数，初始化代币信息并设置初始发行量
     * @param _name 代币名称
     * @param _symbol 代币符号
     * @param _initialSupply 初始发行量（不包含小数位数）
     */
    constructor(string memory _name, string memory _symbol, uint256 _initialSupply) {
        name = _name;
        symbol = _symbol;
        totalSupply = _initialSupply * (10 ** uint256(decimals));
        balanceOf[msg.sender] = totalSupply;
        owner = msg.sender;

        emit Transfer(address(0), msg.sender, totalSupply);
    }

    /**
     * @dev 从调用者地址向目标地址转账
     * @param to 接收方地址
     * @param value 转账金额
     * @return 转账是否成功
     */
    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0), "Transfer to the zero address");
        require(balanceOf[msg.sender] >= value, "Insufficient balance");

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;

        emit Transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev 授权spender从调用者地址转账
     * @param spender 被授权者地址
     * @param value 授权金额
     * @return 授权是否成功
     */
    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), "Approve to the zero address");

        allowance[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev 从from地址向to地址转账，需先获得授权
     * @param from 转出方地址
     * @param to 接收方地址
     * @param value 转账金额
     * @return 转账是否成功
     */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(from != address(0), "Transfer from the zero address");
        require(to != address(0), "Transfer to the zero address");
        require(balanceOf[from] >= value, "Insufficient balance");
        require(allowance[from][msg.sender] >= value, "Allowance exceeded");

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;

        emit Transfer(from, to, value);
        return true;
    }

    /**
     * @dev 增发代币，仅合约所有者可调用
     * @param value 增发金额
     */
    function mint(uint256 value) public {
        require(msg.sender == owner, "Caller is not the owner");
        
        uint256 amount = value;
        totalSupply += amount;
        balanceOf[msg.sender] += amount;

        emit Transfer(address(0), msg.sender, amount);
    }
}