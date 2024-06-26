def create_force_commands(strings):
    force_commands = []
    for index, string in enumerate(strings):
        force_command = f'force -freeze sim:/HazardDetectionUnit/instruction {string} 0\nrun'
        force_commands.append(force_command)
    return '\n'.join(force_commands)

# Example usage:
input_strings = [
                 "0000000000000000", #nop
                 "0000000001111010",
                 "0000000001111100", 
                 "0100000000000000",#not
                 "0100000000001000",
                 "0100000000010000",
                 "0100000000011000",#dec
                 "0100000000100000",
                 "0100000000101001",
                 "0100000000110001",
                 "0100000000111001",
                 "0100000001000000",#out
                 "0100000001001001",
                 "0100000001110000",
                 "0100000001111000",
                 "0100000001100000",#protect
                 "0100000001101000",
                 "0100000001111001",#load
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
                 "1100000000001110",#or
                 "1100000000010000",
                ]
resulting_string = create_force_commands(input_strings)
print(resulting_string)
# vcom -work work -2002 -explicit -O0 {D:/3rd-cmp/First semster/Arch/project/Decode/HazardDetectionUnit.vhd}
#  # Model Technology ModelSim ALTERA vcom 10.1d Compiler 2012.11 Nov  2 2012
#  # -- Loading package STANDARD
# # -- Loading package TEXTIO
# # -- Loading package std_logic_1164
# # -- Loading package NUMERIC_STD
# # -- Compiling entity HazardDetectionUnit
# # -- Compiling architecture ArchHazardDetectionUnit of HazardDetectionUnit
# vsim -voptargs=+acc work.HazardDetectionUnit
# # vsim -voptargs=+acc work.HazardDetectionUnit 
# # Loading std.standard
# # Loading std.textio(body)
# # Loading ieee.std_logic_1164(body)
# # Loading ieee.numeric_std(body)
# # Loading work.HazardDetectionUnit(archHazardDetectionUnit)
# add wave -position insertpoint  \
# sim:/HazardDetectionUnit/instruction \
# sim:/HazardDetectionUnit/ForwordAluEnable \
# sim:/HazardDetectionUnit/zeroOperand \
# sim:/HazardDetectionUnit/oneOperand \
# sim:/HazardDetectionUnit/twoOperand \
# sim:/HazardDetectionUnit/threeOperand
# force -freeze sim:/HazardDetectionUnit/instruction 0000000000000000 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0000000001111010 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0000000001111100 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0100000000000000 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0100000000001000 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0100000000010000 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0100000000011000 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0100000000100000 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0100000000101001 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0100000000110001 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0100000000111001 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0100000001000000 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0100000001001001 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0100000001110000 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0100000001111000 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0100000001100000 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0100000001101000 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0100000001111001 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0100000001110001 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0100000000001010 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0100000000001100 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 0100000000010110 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 1000000000000000 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 1000000000011110 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 1000000000000011 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 1100000000000010 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 1100000000011010 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 1100000000001100 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 1100000000001110 0
# run
# force -freeze sim:/HazardDetectionUnit/instruction 1100000000010000 0
# run