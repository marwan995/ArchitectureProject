vsim -voptargs=+acc work.testbench
add wave -position insertpoint  \
sim:/testbench/clk \
sim:/testbench/rst \
sim:/testbench/instructionPC \
sim:/testbench/writeInstructionEnable \
sim:/testbench/instruction \
sim:/testbench/inputPort \
sim:/testbench/currentInstruction \
sim:/testbench/pc \
sim:/testbench/outputPort \
sim:/testbench/memoryOut \
sim:/testbench/flags \
sim:/testbench/register0 \
sim:/testbench/register1 \
sim:/testbench/register2 \
sim:/testbench/register3 \
sim:/testbench/register4 \
sim:/testbench/register5 \
sim:/testbench/register6 \
sim:/testbench/register7
force -freeze sim:/testbench/rst 1 0
force -freeze sim:/testbench/writeInstructionEnable 0 0
run
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ns  Iteration: 0  Instance: /testbench/MIPS/MemoryStage/protectedMemo
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ns  Iteration: 0  Instance: /testbench/MIPS/MemoryStage/data
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ns  Iteration: 0  Instance: /testbench/MIPS/Fetching/FetchInstruction
force -freeze sim:/testbench/rst 0 0
force -freeze sim:/testbench/writeInstructionEnable 0 0
run
run
run
run
run
run
run
run
run
run
run
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 1200 ns  Iteration: 3  Instance: /testbench/MIPS/MemoryStage/protectedMemo
run
run
run
run
run
run
run
run