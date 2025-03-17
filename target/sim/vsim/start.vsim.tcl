# No license needed

set TESTBENCH testbench

set VOPTARGS "-O5 +acc"

eval "vsim -c ${TESTBENCH} -t 1ps -vopt -voptargs=\"${VOPTARGS}\""
eval "add log -r sim:/testbench/*"
