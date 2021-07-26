#!/bin/bash

# Tested at x86-64

# Error Checking 
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


# File Sizes
echo -en "------------\nSource Size: "
du -sb ${1}.s
echo -n  "Object File Size: "
du -sb ${1}.o
echo -n  "Executable Size: "
du -sb ${1}


echo "Executing: ${1}"
time ./${1}
ret=$?
echo -n "Return Value: "
echo $ret
