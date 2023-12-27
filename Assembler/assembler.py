# import  the needed libraries
import sys
instructions_map = {
    # 0 operand
    'NOP': {'opcode': "0000000000000000", 'number_of_operands': 0, 'is_immediate': 0, 'is_ea': 0},
    'RET': {'opcode': "0000000001111010", 'number_of_operands': 0, 'is_immediate': 0, 'is_ea': 0},
    'RTI': {'opcode': "0000000001111100", 'number_of_operands': 0, 'is_immediate': 0, 'is_ea': 0},
    # 1 operand
    'NOT': {'opcode': "01R00000000000", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'NEG': {'opcode': "01R00000001000", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'INC': {'opcode': "01R00000010000", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'DEC': {'opcode': "01R00000011000", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'IN': {'opcode': "01R00000100000", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'BITSET': {'opcode': "01R00000101001", 'number_of_operands': 1, 'is_immediate': 1, 'is_ea': 0},
    'RCL': {'opcode': "01R00000110001", 'number_of_operands': 1, 'is_immediate': 1, 'is_ea': 0},
    'RCR': {'opcode': "01R00000111001", 'number_of_operands': 1, 'is_immediate': 1, 'is_ea': 0},
    'OUT': {'opcode': "01R00001000000", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'LDM': {'opcode': "01R00001001001", 'number_of_operands': 1, 'is_immediate': 1, 'is_ea': 0},
    'PUSH': {'opcode': "01R00001110000", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'POP': {'opcode': "01R00001111000", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'PROTECT': {'opcode': "01R00001100000", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'FREE': {'opcode': "01R00001101000", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'LDD': {'opcode': "01R00001111001", 'number_of_operands': 1, 'is_immediate': 1, 'is_ea': 1},
    'STD': {'opcode': "01R00001110001", 'number_of_operands': 1, 'is_immediate': 1, 'is_ea': 1},
    # jumps instructions
    'JZ': {'opcode': "01R00000001010", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'JMP': {'opcode': "01R00000001100", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'CALL': {'opcode': "01R00000010110", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    # 2 operand
    'SWAP': {'opcode': "10RR00000000", 'number_of_operands': 2, 'is_immediate': 0, 'is_ea': 0},
    'CMP': {'opcode': "10RR00011110", 'number_of_operands': 2, 'is_immediate': 0, 'is_ea': 0},
    'ADDI': {'opcode': "10RR00000011", 'number_of_operands': 2, 'is_immediate': 1, 'is_ea': 0},
    # 3 operand
    'ADD': {'opcode': "11RRR00010", 'number_of_operands': 3, 'is_immediate': 0, 'is_ea': 0},
    'SUB': {'opcode': "11RRR11010", 'number_of_operands': 3, 'is_immediate': 0, 'is_ea': 0},
    'XOR': {'opcode': "11RRR01100", 'number_of_operands': 3, 'is_immediate': 0, 'is_ea': 0},
    'OR': {'opcode': "11RRR01110", 'number_of_operands': 3, 'is_immediate': 0, 'is_ea': 0},
    'AND': {'opcode': "11RRR10000", 'number_of_operands': 3, 'is_immediate': 0, 'is_ea': 0},
}


def read_instruction_file():
    if len(sys.argv) < 2:
        print(f"Error : please provide the path for the instructions file")
        sys.exit(0)
    instruction_path = sys.argv[1]
    with open(instruction_path, "r") as instruction_file:
        instructions = instruction_file.read().splitlines()
        if len(instructions) == 0:
            print(f"Warning : this is just an empty file")
            exit(0)

        return instructions


def encode_registers_numbers(register_name: str):
    if len(register_name) > 2:
        print(
            f"Error : this is not a register reference expected R<number> format\nline of instruction --> {line_number} : {current_instruction}")
        exit(0)
    if register_name[0] != 'R':
        print(
            f"Error : invalid register expected R<number> format\nline of instruction --> {line_number} : {current_instruction}")
        exit(0)
    if 7 < int(register_name[1]) or 0 > int(register_name[1]):
        print(
            f"Error : invalid register range expected  from 0 to 7\nline of instruction --> {line_number} : {current_instruction}")
        exit(0)
    return format(int(register_name[1]), '03b')


def update_opcode_with_registers(instruction: str, register_array: []):
    for register in register_array:
        register_number = encode_registers_numbers(register)
        instruction = instruction.replace('R', register_number, 1)
    return instruction


def encode_assembly_line(instruction: str):
    tokenize_instruction = instruction.split()
    if tokenize_instruction[0] not in instructions_map:
        print(
            f"sorry we don't support that type of instruction yet\nline of instruction --> {line_number} : {current_instruction}")
        exit(0)

    instruction_coded = instructions_map.get(tokenize_instruction[0])

    if len(tokenize_instruction)-1 != instruction_coded["number_of_operands"]+instruction_coded["is_immediate"]:
        print(
            f'Error : number of parameters do not match expected {instruction_coded["number_of_operands"]+instruction_coded["is_immediate"]}\nline of instruction --> {line_number} : {current_instruction}')
        exit(0)

    instruction_opCode = instruction_coded["opcode"]

    register_array = tokenize_instruction[1:1 +
                                          instruction_coded["number_of_operands"]]
    instruction_opCode_with_regs = update_opcode_with_registers(
        instruction_opCode, register_array)
    if not instruction_coded["is_immediate"]:
        return instruction_opCode_with_regs
    instruction_opCode_immediate = immediate_to_binary(instruction_opCode_with_regs, tokenize_instruction[-1], (
        instruction_coded["is_immediate"] and (instruction_coded["is_ea"] == 0)), instruction_coded["is_ea"])
    return instruction_opCode_immediate


def get_decimal(immediate_value: str):
    try:
        base = 10  # Default base is decimal
        if immediate_value.endswith('H'):
            base = 16  # Hexadecimal
            immediate_value = immediate_value[:-1]
        elif immediate_value.endswith('O'):
            base = 8   # Octal
            immediate_value = immediate_value[:-1]
        elif immediate_value.endswith('B'):
            base = 2   # Binary
            immediate_value = immediate_value[:-1]
        immediate_int = int(immediate_value, base)
        if immediate_int < 0:
            print(
                f"Error : Negative numbers are not allowed.\nline of instruction --> {line_number} : {current_instruction}")
            exit(0)
        return immediate_int
    except ValueError as e:
        print(
            f"Error : {e}\nline of instruction --> {line_number} : {current_instruction}")
        exit(0)


def immediate_to_binary(instruction: str, immediate_value: str, is_immediate: int, is_ea: int):
    immediate_int = get_decimal(immediate_value)
    if is_immediate and not (0 <= immediate_int <= 0xFFFF):
        print(
            f"Error : exceeds 65535 limit.\nline of instruction --> {line_number} : {current_instruction}")
        exit(0)
    if is_ea:
        if not (0 <= immediate_int <= 0xFFFFF):
            print(
                f"Error : invalid address\nline of instruction --> {line_number} : {current_instruction}")
            exit(0)
        ea_bits = format(immediate_int >> 16, "04b")
        instruction = instruction[:5] + ea_bits + instruction[9:]
        immediate_int &= 0xFFFF
    binary_representation = format(immediate_int, "016b")

    return f'{instruction}\n{binary_representation}'


def process_instruction_file():
    global line_number, current_instruction
    instruction_lines = read_instruction_file()
    output_filename = sys.argv[2] if len(sys.argv) > 2 else "output.txt"

    processed_lines_string = ""

    for i, instruction_line in enumerate(instruction_lines, start=1):
        line_number = i
        current_instruction = instruction_line
        processed_line = encode_assembly_line(instruction_line.upper())
        processed_lines_string += f"{processed_line}\n"

    with open(output_filename, "w") as output_file:
        output_file.write(processed_lines_string)


if __name__ == "__main__":
    # Call the main function
    process_instruction_file()
