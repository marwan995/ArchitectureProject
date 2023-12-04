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