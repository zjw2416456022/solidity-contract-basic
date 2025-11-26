// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract SimpleToken {
    // 状态变量
    string public name = "My Token";
    string public symbol = "MTK";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;
    mapping(address => uint256) public balanceOf;

    // 事件
    event Transfer(address indexed from, address indexed to, uint256 value);

    // 构造函数
    constructor(uint256 _initialSupply) {
        owner = msg.sender;
        /*
        为什么需要转换成uint256？
        这是为了满足 Solidity 的类型安全要求。在 Solidity 中，进行数学运算（如乘法 * 和幂运算 **）的两个操作数，必须是相同的类型，或者可以被编译器安全地隐式转换。
        */
        totalSupply = _initialSupply * 10 ** uint256(decimals); // **幂运算，10的18次方
    }
    // 转账函数
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "Cannot transfer to zero address");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    // 查询余额
    function getBalance(address _owner) public view returns (uint256) {
        return balanceOf[_owner];
    }
    // 铸造代币（仅owner）
    function mint(address _to, uint256 _amount) public {
        require(msg.sender == owner, "Only owner can mint"); //参数一为trun才能过
        require(_to != address(0), "Cannot mint to zero address");
        
        totalSupply += _amount;
        balanceOf[msg.sender] += _amount;
        emit Transfer(address(0), _to, _amount);
    }
}
