#!/bin/bash

# Tested at x86-64

if [ -z $1 ]; then 
    echo "Error no argument passed!"
    exit 1
fi

echo -e "Assembling: ${1}.s --> ${1}.o"
as ${1}.s -o ${1}.o

if [[ $? != 0 ]]; then
    echo "Assembler Error!"
    exit 1
fi

echo -e "Linking: ${1}.o --> ${1}"
ld ${1}.o -o ${1}

if [[ $? != 0 ]]; then 
    echo "Linker Error!"
    exit 1
fi


echo "Executing: ${1}"
./${1}
ret=$?
echo -n "Return Value: "
echo $ret
