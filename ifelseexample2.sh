#!/bin/bash
# when condition is true
# True && FALSE ||FALSE||TRUE
if [[ 10 -gt 9 && 10 == 9 || 2 -lt 1 || 25 -gt 20 ]]; 
then
  echo "Given condition is true."
  else
   echo "Given condition is false."
   fi
   # When condition is false  
#TRUE && FALSE || FALSE || TRUE  
if [[ 10 -gt 9 && 10 == 8 || 3 -gt 4 || 8 -gt 8 ]]; 
then
echo "Given condition is true."
else
  echo "Given condition is not true"
  fi