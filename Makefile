# No license needed

Bender := ./bender
bender-targs := -t simulation

bender:
	curl --proto '=https' --tlsv1.2 https://pulp-platform.github.io/bender/init -sSf | sh

CompileScript := target/sim/vsim/compile.tcl

.PHONY: $(CompileScript)
$(CompileScript):
	bender script vsim $(bender-targs) > $@

compile: $(CompileScript)
