def switch_case(case_type):
    cases = {
        "type1": "DevOps Department",
        "type2": "QA",
        "type3": "Developing",
    }
    return cases.get(case_type, "Invalid Type")  # Default case

# Example Usage
case_type = input("Enter case type: ")  # User input for demonstration
print(switch_case(case_type))
