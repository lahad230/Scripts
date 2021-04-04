#!/bin/bash
PASS=$1
OK=0
REASON=""
# check length
if [ ${#PASS} -ge 10 ]; then
    ((OK++))
else
    REASON+=" no 10"
fi
# check capitals
if [[ $PASS =~ [A-Z] ]]; then 
    ((OK++))
else
    REASON+=" no big"
fi
# check numbers
if [[ $PASS =~ [0-9] ]]; then 
    ((OK++))
else
    REASON+=" no num"
fi
# check small letters
if [[ $PASS =~ [a-z] ]]; then 
    ((OK++))
else
    REASON+=" no small"
fi
if [ $OK == 4 ]; then 
    tput setaf 2; echo "This is an awesome password!" 
    exit 0
else 
    tput setaf 1; echo "Weak Password$REASON."
    exit 1
fi 