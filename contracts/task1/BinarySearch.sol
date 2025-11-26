// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

/**
 * 二分查找 (Binary Search)
 * 题目描述：在一个有序数组中查找目标值。
 */
contract BinarySearch {
    
    function search(int256[] memory nums, int256 target) public pure returns (int256) {
        if (nums.length == 0) {
            return -1;
        }

        uint256 left = 0; // 左指针：指向数组起始位置
        uint256 right = nums.length - 1;// 右指针：指向数组末尾

        while (left <= right) {
            uint256 mid = (right - left) / 2 + left;
            int256 num = nums[mid]; // 中间位置的元素值

            // 情况1：找到目标值 → 返回当前索引
            if (num == target) {
                return int256(mid);
            }
            // 情况2：中间值 > 目标值 → 目标在左半部分，右指针左移（mid-1）
            else if (num > target) {
                right = mid - 1;
            }
            // 情况3：中间值 < 目标值 → 目标在右半部分，左指针右移（mid+1）
            else {
                left = mid + 1;
            }
        }

        return -1;
    }
}