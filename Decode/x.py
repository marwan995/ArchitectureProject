def create_force_commands(strings):
    force_commands = []
    for index, string in enumerate(strings):
        force_command = f'force -freeze sim:/controlunit/instruction {string} 0\nrun'
        force_commands.append(force_command)
    return '\n'.join(force_commands)

# Example usage:
input_strings = ["0000000000000000", 
                 "0000000001111010",
                 "0000000001111100", 
                 "0100000000000000",
                 "0100000000001000",
                 "0100000000010000",
                 "0100000000011000",
                 "0100000000100000",
                 "0100000000101001",
                 "0100000000110001",
                 "0100000000111001",
                 "0100000001000000",
                 "0100000001001001",
                 "0100000001110000",
                 "0100000001111000",
                 "0100000001100000",
                 "0100000001101000",
                 "0100000001111001",
                 "0100000001110001",
                 "0100000000001010",
                 "0100000000001100",
                 "0100000000010110",
                 "1000000000000000",
                 "1000000000011110",
                 "1000000000000011",
                 "1100000000000010",
                 "1100000000011010",
                 "1100000000001100",
                 "1100000000001110",
                 "1100000000010000",
                ]
resulting_string = create_force_commands(input_strings)
print(resulting_string)
# vcom -work work -2002 -explicit -O0 {D:/3rd-cmp/First semster/Arch/project/Decode/ControlUnit.vhd}
#  # Model Technology ModelSim ALTERA vcom 10.1d Compiler 2012.11 Nov  2 2012
#  # -- Loading package STANDARD
# # -- Loading package TEXTIO
# # -- Loading package std_logic_1164
# # -- Loading package NUMERIC_STD
# # -- Compiling entity ControlUnit
# # -- Compiling architecture ArchControlUnit of ControlUnit
# vsim -voptargs=+acc work.controlunit
# # vsim -voptargs=+acc work.controlunit 
# # Loading std.standard
# # Loading std.textio(body)
# # Loading ieee.std_logic_1164(body)
# # Loading ieee.numeric_std(body)
# # Loading work.controlunit(archcontrolunit)
# add wave -position insertpoint  \
# sim:/controlunit/instruction \
# sim:/controlunit/readOrWrite \
# sim:/controlunit/zeroOperand \
# sim:/controlunit/oneOperand \
# sim:/controlunit/twoOperand \
# sim:/controlunit/threeOperand
# force -freeze sim:/controlunit/instruction 0000000000000000 0
# run
# force -freeze sim:/controlunit/instruction 0000000001111010 0
# run
# force -freeze sim:/controlunit/instruction 0000000001111100 0
# run
# force -freeze sim:/controlunit/instruction 0100000000000000 0
# run
# force -freeze sim:/controlunit/instruction 0100000000001000 0
# run
# force -freeze sim:/controlunit/instruction 0100000000010000 0
# run
# force -freeze sim:/controlunit/instruction 0100000000011000 0
# run
# force -freeze sim:/controlunit/instruction 0100000000100000 0
# run
# force -freeze sim:/controlunit/instruction 0100000000101001 0
# run
# force -freeze sim:/controlunit/instruction 0100000000110001 0
# run
# force -freeze sim:/controlunit/instruction 0100000000111001 0
# run
# force -freeze sim:/controlunit/instruction 0100000001000000 0
# run
# force -freeze sim:/controlunit/instruction 0100000001001001 0
# run
# force -freeze sim:/controlunit/instruction 0100000001110000 0
# run
# force -freeze sim:/controlunit/instruction 0100000001111000 0
# run
# force -freeze sim:/controlunit/instruction 0100000001100000 0
# run
# force -freeze sim:/controlunit/instruction 0100000001101000 0
# run
# force -freeze sim:/controlunit/instruction 0100000001111001 0
# run
# force -freeze sim:/controlunit/instruction 0100000001110001 0
# run
# force -freeze sim:/controlunit/instruction 0100000000001010 0
# run
# force -freeze sim:/controlunit/instruction 0100000000001100 0
# run
# force -freeze sim:/controlunit/instruction 0100000000010110 0
# run
# force -freeze sim:/controlunit/instruction 1000000000000000 0
# run
# force -freeze sim:/controlunit/instruction 1000000000011110 0
# run
# force -freeze sim:/controlunit/instruction 1000000000000011 0
# run
# force -freeze sim:/controlunit/instruction 1100000000000010 0
# run
# force -freeze sim:/controlunit/instruction 1100000000011010 0
# run
# force -freeze sim:/controlunit/instruction 1100000000001100 0
# run
# force -freeze sim:/controlunit/instruction 1100000000001110 0
# run
# force -freeze sim:/controlunit/instruction 1100000000010000 0
# run