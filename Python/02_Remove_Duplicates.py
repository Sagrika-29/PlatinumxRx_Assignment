# 02_Remove_Duplicates.py
# Removes duplicate characters while preserving the first occurrence order.

def remove_duplicates(s: str) -> str:
    """Return a string with duplicate characters removed."""
    result = ""
    for ch in s:
        if ch not in result:
            result += ch
    return result


# Direct execution
if __name__ == "__main__":
    s = input("Enter string: ")
    print(remove_duplicates(s))
