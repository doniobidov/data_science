# Given a string s, find the length of the longest substring without repeating characters.

def lengthOfLongestSubstring(self, s: str) -> int:
    max_length = 0
    hash_set = set()
    l = 0
    for r in range(len(s)):
        while s[r] in hash_set:
            hash_set.remove(s[r])
            l += 1
        hash_set.add(s[r])
        max_length = max(max_length, r - l + 1)
    return max_length