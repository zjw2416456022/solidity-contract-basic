// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract TypeConversionPractice {
    function safeConvertToUint8(uint256 value) public pure returns (uint8) {
        // TODO: 添加范围检查
        // 如果value大于255，应该revert
        require(value <= type(uint8).max, "Value too large for uint8");
        return uint8(value);
    }

    function compareStrings(
        string memory a,
        string memory b
    ) public pure returns (bool) {
        // TODO: 实现字符串比较
        // 提示：使用keccak256
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }

    function isZeroAddress(address addr) public pure returns (bool) {
        return addr == address(0);
    }
}
