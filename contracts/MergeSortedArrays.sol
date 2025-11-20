// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

/**
 * 合并两个有序数组 (Merge Sorted Array)
 * 题目描述：将两个有序数组合并为一个有序数组。
 */
contract MergeSortedArrays {
    function merge(
        int256[] memory nums1, 
        uint256 m,
        int256[] memory nums2,
        uint256 n
    ) public pure {
        // 输入合法性校验（避免数组越界、长度不匹配等异常）
        require(
            nums1.length == m + n,
            "nums1 length must be m + n (insufficient space)"
        );
        require(nums2.length == n, "nums2 length must equal n");
        require(
            m <= nums1.length && n <= nums2.length,
            "m/n exceeds array length"
        );

        int256[] memory sorted = new int256[](m + n); // 临时存储合并结果的数组（长度 = 总元素数）
        uint256 p1 = 0; // nums1 有效元素的指针（指向当前待比较元素）
        uint256 p2 = 0; // nums2 元素的指针（指向当前待比较元素）
        uint256 idx = 0; // sorted 数组的写入指针（指向当前待写入位置）

        // 双指针核心合并逻辑（升序拼接）
        while (true) {
            // 情况1：nums1 的有效元素已遍历完，拼接 nums2 剩余元素
            if (p1 == m) {
                // 循环添加 nums2 从 p2 到末尾的所有元素
                while (p2 < n) {
                    sorted[idx] = nums2[p2];
                    idx++;
                    p2++;
                }
                break;
            }

            // 情况2：nums2 的元素已遍历完，拼接 nums1 剩余有效元素
            if (p2 == n) {
                // 循环添加 nums1 从 p1 到 m-1 的所有有效元素
                while (p1 < m) {
                    sorted[idx] = nums1[p1];
                    idx++;
                    p1++;
                }
                break;
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

        // 将合并后的 sorted 数组复制到 nums1
        for (uint256 i = 0; i < sorted.length; i++) {
            nums1[i] = sorted[i];
        }
    }
}
