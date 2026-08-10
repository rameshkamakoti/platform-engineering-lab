def has_duplicate(nums):
    return len(nums) != len(set(nums))


numbers1 = [1, 2, 3, 4, 5]
numbers2 = [1, 2, 2, 4, 5]

print(has_duplicate(numbers1))
print(has_duplicate(numbers2))
