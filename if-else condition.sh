#!/bin/bash

# Prompt the user to enter a number
echo "Enter a number:"
read number

# Check if the number is positive, negative, or zero
if [ $number -gt 0 ]; then
    echo "The number $number is positive."
elif [ $number -lt 0 ]; then
    echo "The number $number is negative."
else
    echo "The number is zero."
fi

#If the number is greater than 0, it is positive.
#If the number is less than 0, it is negative.
#If neither condition is true, the number is zero.
#Based on the condition, the corresponding message is printed.
#Key Points About Conditional Operators:
#-eq: Equal to.
#-ne: Not equal to.
#-gt: Greater than.
#-lt: Less than.
#-ge: Greater than or equal to.
