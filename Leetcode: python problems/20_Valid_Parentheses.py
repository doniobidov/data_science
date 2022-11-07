# Given a string s containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid.
# An input string is valid if:
# Open brackets must be closed by the same type of brackets.
# Open brackets must be closed in the correct order.
# Every close bracket has a corresponding open bracket of the same type.

def isValid(self, s: str) -> bool:
    hash_map = {')': '(', '}': '{', ']': '['}
    stack = []
    for character in s:
        if character in hash_map:
            if stack and stack[-1] == hash_map[character]:
                stack.pop()
            else:
                return False
        else:
            stack.append(character)
    return True if not stack else False