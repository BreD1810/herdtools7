#!/bin/bash

mkdir -p litmus-testing
cd litmus-testing

TESTS=$(find ../litmus/tests/AArch64.neon/ | grep -E "*.litmus$")
STATUS=0

for test in $TESTS; do
    rm -f *.c *.t *.sh *.exe *.h *.o *.awk *.txt
    name=$(basename $test .litmus)
    tar xf ../$name.tar
    if [[ $? -ne 0 ]]; then
        echo "Cannot find ${name}.tar" 2>&1
        STATUS=1
        continue
    fi
    
    chmod +x comp.sh
    ./comp.sh
    if [[ $? -ne 0 ]]; then
        STATUS=1
        continue
    fi

    ./$name.exe | head -n -1 > result.txt
    if ! cmp --silent -- result.txt "../litmus/tests/AArch64.neon/$name.litmus.expected"; then
        echo "Execution output does not match for $name" 2>&1
        STATUS=1
        continue
    fi

    echo "Success for $name"
done

exit $STATUS
