// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

/**
    反转字符串 (Reverse String)
    题目描述：反转一个字符串。输入 "abcde"，输出 "edcba"
 */

contract StringReverser {
    function reverseString(string memory input) public pure returns(string memory){
        bytes memory inputBytes=bytes(input);
        uint256 length = inputBytes.length;
        if (length<=1) {
            return input;
        }
        uint256 start = 0;
        uint256 end = length-1;
        while (start < end) {
            bytes1 temp = inputBytes[start];
            inputBytes[start]=inputBytes[end];
            inputBytes[end]=temp;
            start++;
            end--;
        }
        return string(inputBytes);
    }
} 