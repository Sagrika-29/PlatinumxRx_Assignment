# 01_Time_Converter.py
# Converts minutes into human readable format: "X hrs Y minutes"

def convert_minutes(total_minutes: int) -> str:
    if total_minutes < 0:
        raise ValueError("Minutes must be non-negative")

    hours = total_minutes // 60
    minutes = total_minutes % 60

    hrs_label = "hr" if hours == 1 else "hrs"
    min_label = "minute" if minutes == 1 else "minutes"

    return f"{hours} {hrs_label} {minutes} {min_label}"


# Run the script directly
if __name__ == "__main__":
    n = input("Enter minutes: ")
    try:
        mins = int(n)
        print(convert_minutes(mins))
    except ValueError:
        print("Please enter a valid integer number of minutes")
