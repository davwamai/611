#!/bin/bash

vlog -pedanticerrors -lint -hazards -source -stats=all alu.sv controlunit.sv cpu.sv en_pipeline_register.sv hexdriver.sv mux21.sv mux31.sv pipeline_register.sv regfile.sv sign_extend.sv top.sv simtop2.sv
printf "run\n" | vsim -pedanticerrors -hazards -c -sva -immedassert work.simtop2 -do /dev/stdin
