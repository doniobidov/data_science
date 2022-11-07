# Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.
# You may assume that each input would have exactly one solution, and you may not use the same element twice.

def twoSum(self, nums: List[int], target: int) -> List[int]:
    hash_map = {}
    for i, num in enumerate(nums):
        match = target - num
        if match in hash_map:
            return [hash_map[match], i]
        hash_map[num] = i