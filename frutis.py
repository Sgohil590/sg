def switch_case (case_type):
    cases = {
        "1": "banana",
        "2": "apple",
        "3": "orange",
        "4": "ladies finger",
        "5": "vegetabels",
        "40": "nuts",
   }
    return cases.get(case_type, "Invalid Type")
# Example Usage
case_type = input("Enter case type: ")  # User input for demonstration
print(switch_case(case_type))
