// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

/**
 * 合并两个有序数组 (Merge Sorted Array)
 * 题目描述：将两个有序数组合并为一个有序数组。
 */
contract MergeSortedArrays {
   
    function merge(
        int256[] memory nums1,  // Solidity 用 int256 覆盖 Go 的 int 数值范围
        uint256 m,             // 无符号整数，适配数组索引特性
        int256[] memory nums2,
        uint256 n
    ) public pure {
        // 1. 输入合法性校验（避免数组越界、长度不匹配等异常）
        require(nums1.length == m + n, "nums1 length must be m + n (insufficient space)");
        require(nums2.length == n, "nums2 length must equal n");
        require(m <= nums1.length && n <= nums2.length, "m/n exceeds array length");

        // 2. 初始化辅助变量（对齐 Go 逻辑）
        int256[] memory sorted = new int256[](m + n);  // 临时存储合并结果的数组（长度 = 总元素数）
        uint256 p1 = 0;  // nums1 有效元素的指针（指向当前待比较元素）
        uint256 p2 = 0;  // nums2 元素的指针（指向当前待比较元素）
        uint256 idx = 0; // sorted 数组的写入指针（指向当前待写入位置）

        // 3. 双指针核心合并逻辑（升序拼接）
        while (true) {
            // 情况1：nums1 的有效元素已遍历完，拼接 nums2 剩余元素
            if (p1 == m) {
                // 循环添加 nums2 从 p2 到末尾的所有元素（Solidity 无切片直接拼接，需循环实现）
                while (p2 < n) {
                    sorted[idx] = nums2[p2];
                    idx++;
                    p2++;
                }
                break; // 所有元素拼接完成，退出外层循环
            }

            // 情况2：nums2 的元素已遍历完，拼接 nums1 剩余有效元素
            if (p2 == n) {
                // 循环添加 nums1 从 p1 到 m-1 的所有有效元素
                while (p1 < m) {
                    sorted[idx] = nums1[p1];
                    idx++;
                    p1++;
                }
                break; // 所有元素拼接完成，退出外层循环
            }

            // 情况3：两者均有未遍历元素，按升序取较小值拼接
            if (nums1[p1] < nums2[p2]) {
                sorted[idx] = nums1[p1];
                p1++; // nums1 指针后移，指向 next 待比较元素
            } else {
                sorted[idx] = nums2[p2];
                p2++; // nums2 指针后移，指向 next 待比较元素
            }
            idx++; // sorted 写入指针后移，准备下一次写入
        }

        // 4. 将合并后的 sorted 数组复制到 nums1（覆盖原数据，对齐 Go 的 copy 逻辑）
        // Solidity 内置 copy 函数：copy(目标数组, 源数组)，自动按数组长度复制
        copy(nums1, sorted);
    }
}