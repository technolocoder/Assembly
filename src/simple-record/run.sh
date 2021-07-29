if [ -z $1 ]; then
    echo "Error no argument passed!"
    exit -1
fi

../run.sh $1

./$1 $2
echo $?