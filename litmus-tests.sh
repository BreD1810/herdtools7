#!/bin/bash

TESTS=$(find litmus/tests/AArch64.neon/ | grep -E "*.litmus$")
STATUS=0

for test in $TESTS; do
    name=$(basename $test .litmus)
    output=$(_build/default/litmus/litmus.exe -o $name.tar $test 2>&1)
    if [[ $output ]]; then
        echo "Failed to compile ${name}: ${output}" 1>&2
        STATUS=1
    fi
done

exit $STATUS
