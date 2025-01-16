#!/bin/bash
# Prompt the user for input
echo "Enter a greeting (e.g., hello, Hello, HELLO):"
read greeting

# Case-sensitive comparison using `if-elif-else`
if [ "$greeting" = "hello" ]; then
    echo "You entered 'hello' in lowercase."
elif [ "$greeting" = "Hello" ]; then
    echo "You entered 'Hello' with the first letter capitalized."
elif [ "$greeting" = "HELLO" ]; then
    echo "You entered 'HELLO' in uppercase."
else
    echo "Your input does not match 'hello', 'Hello', or 'HELLO'."
fi
