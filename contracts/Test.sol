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
        require(
            nums1.length == m + n,
            "nums1 length must be m + n (insufficient space)"
        );
        require(nums2.length == n, "nums2 length must equal n");
        require(
            m <= nums1.length && n <= nums2.length,
            "m/n exceeds array length"
        );

        int256[] memory sorted = new int256[](m + n);
        uint256 p1 = 0;
        uint256 p2 = 0;
        uint256 idx = 0;

        while (true) {
            if (p1 == m) {
                while (p2 < n) {
                    sorted[idx] = nums2[p2];
                    idx++;
                    p2++;
                }
                break;
            }

            if (p2 == n) {
                while (p1 < m) {
                    sorted[idx] = nums1[p1];
                    idx++;
                    p1++;
                }
                break;
            }

            if (nums1[p1] < nums2[p2]) {
                sorted[idx] = nums1[p1];
                p1++;
            } else {
                sorted[idx] = nums2[p2];
                p2++;
            }
            idx++;
        }
        for (uint256 i = 0; i < sorted.length; i++) {
            nums1[i] = sorted[i];
        }
    }
}
