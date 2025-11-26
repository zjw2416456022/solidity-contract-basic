// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

/**
    题目描述：用 solidity 实现罗马数字转数整数
 */

contract RomanInteger {
    mapping(bytes1 => uint256) private symbolValues;
    constructor() {
         // 定义罗马符号→数值映射
        symbolValues['I'] = 1;
        symbolValues['V'] = 5;
        symbolValues['X'] = 10;
        symbolValues['L'] = 50;
        symbolValues['C'] = 100;
        symbolValues['D'] = 500;
        symbolValues['M'] = 1000;

    }
    function RomanToInteger(string memory s) public view returns(uint256 ans){
        // 将 string 转为 bytes 数组（Solidity 需通过 bytes 索引访问单个字符）
        bytes memory sBytes = bytes(s);
        uint256 n = sBytes.length;
        for (uint256 i = 0; i < n; i++) {
            bytes1 currentChar = sBytes[i];
            uint256 currentValue = symbolValues[currentChar];
            // 校验：输入非法罗马字符（不在映射中，value 为 0）
            require(currentValue != 0, "Invalid Roman character");
            // 若当前不是最后一个字符，且当前值 < 下一个值 → 减当前值（特殊组合）
            if (i < n - 1) {
                uint256 nextValue = symbolValues[sBytes[i + 1]];
                if (currentValue < nextValue) {
                    ans -= currentValue;
                    continue; 
                }
            }
            // 普通情况：加当前值
            ans += currentValue;
        }
        // 校验：罗马数字结果范围（1~3999）
        require(ans >= 1 && ans <= 3999, "Result out of valid range (1~3999)");
        return ans;
    }
   
} 