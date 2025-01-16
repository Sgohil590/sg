#!/bin/bash
#promt the user enter a number
echo "please enter a number (1,2 or 3):"
read number
#Check the entered number and print the corresponding department
if [ "$number" -eq 1 ]; then
  echo "your departement is devops."
  elif [ "$number" -eq 2 ]; then
    echo "your departement is QA."
    elif [ "$number" -eq 3 ]; then
      echo "your departement is Developing."
       else 
        echo "Invalid input please enter 1,2, or 3."
        fi 