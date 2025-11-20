// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

/**
    题目描述：用 solidity 实现整数转罗马数字
 */

contract IntegerRoman {
    // 定义罗马数字核心组合（数值从大到小排序，优先匹配特殊组合）
    // 包含普通组合（如1000=M）和特殊组合（如900=CM、40=XL）
    struct RomanPair {
        uint256 value;   // 对应整数
        string symbol;   // 对应罗马符号
    }
    RomanPair[] private valueSymbols;
    constructor() {
        valueSymbols.push(RomanPair(1000, "M"));
        valueSymbols.push(RomanPair(900, "CM"));
        valueSymbols.push(RomanPair(500, "D"));
        valueSymbols.push(RomanPair(400, "CD"));
        valueSymbols.push(RomanPair(100, "C"));
        valueSymbols.push(RomanPair(90, "XC"));
        valueSymbols.push(RomanPair(50, "L"));
        valueSymbols.push(RomanPair(40, "XL"));
        valueSymbols.push(RomanPair(10, "X"));
        valueSymbols.push(RomanPair(9, "IX"));
        valueSymbols.push(RomanPair(5, "V"));
        valueSymbols.push(RomanPair(4, "IV"));
        valueSymbols.push(RomanPair(1, "I"));
    }
    
    function intToRoman(uint256 num) public view returns (string memory) {
        bytes memory roman = new bytes(0);
        uint256 remaining = num;
        require(remaining >= 1 && remaining <= 3999, "Input must be 1~3999");

        for (uint256 i = 0; i < valueSymbols.length; i++) {
            RomanPair memory vs = valueSymbols[i];
            while (remaining >= vs.value) {
                remaining -= vs.value;
                roman = bytes.concat(roman, bytes(vs.symbol));
            }
            if (remaining == 0) break;
        }
        return string(roman);
    }
} 