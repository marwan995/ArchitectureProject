# import  the needed libraries
import sys

instructions_map = {
    # 0 operand
    'NOP': {'opcode': "0000000000000000", 'number_of_operands': 0, 'is_immediate': 0},
    'RET': {'opcode': "0000000001111010", 'number_of_operands': 0, 'is_immediate': 0},
    'RTI': {'opcode': "0000000001111100", 'number_of_operands': 0, 'is_immediate': 0},
    # 1 operand
    'NOT': {'opcode': "0100000000000000", 'number_of_operands': 1, 'is_immediate': 0},
    'NEG': {'opcode': "0100000000001000", 'number_of_operands': 1, 'is_immediate': 0},
    'INC': {'opcode': "0100000000010000", 'number_of_operands': 1, 'is_immediate': 0},
    'DEC': {'opcode': "0100000000011000", 'number_of_operands': 1, 'is_immediate': 0},
    'IN': {'opcode': "0100000000100000", 'number_of_operands': 1, 'is_immediate': 0},
    'BITSET': {'opcode': "0100000000101001", 'number_of_operands': 1, 'is_immediate': 1},
    'RCL': {'opcode': "0100000000110001", 'number_of_operands': 1, 'is_immediate': 1},
    'RCR': {'opcode': "0100000000111001", 'number_of_operands': 1, 'is_immediate': 1},
    'OUT': {'opcode': "0100000001000000", 'number_of_operands': 1, 'is_immediate': 0},
    'LDM': {'opcode': "0100000001001001", 'number_of_operands': 1, 'is_immediate': 1},
    'Push': {'opcode': "0100000001110000", 'number_of_operands': 1, 'is_immediate': 0},
    'POP': {'opcode': "0100000001111000", 'number_of_operands': 1, 'is_immediate': 0},
    'PROTECT': {'opcode': "0100000001100000", 'number_of_operands': 1, 'is_immediate': 0},
    'FREE': {'opcode': "0100000001101000", 'number_of_operands': 1, 'is_immediate': 0},
    'LDD': {'opcode': "0100000001111001", 'number_of_operands': 1, 'is_immediate': 1},
    'STD': {'opcode': "0100000001110001", 'number_of_operands': 1, 'is_immediate': 1},
    # jumps instructions
    'JZ': {'opcode': "0100000000001010", 'number_of_operands': 1, 'is_immediate': 0},
    'JMP': {'opcode': "0100000000001100", 'number_of_operands': 1, 'is_immediate': 0},
    'CALL': {'opcode': "0100000000010110", 'number_of_operands': 1, 'is_immediate': 0},
    # 2 operand
    'SWAP': {'opcode': "1000000000000000", 'number_of_operands': 2, 'is_immediate': 0},
    'CMP': {'opcode': "1000000000011110", 'number_of_operands': 2, 'is_immediate': 0},
    'ADDI': {'opcode': "1000000000000011", 'number_of_operands': 2, 'is_immediate': 1},
    # 3 operand
    'ADD': {'opcode': "1100000000000010", 'number_of_operands': 3, 'is_immediate': 0},
    'SUB': {'opcode': "1100000000011010", 'number_of_operands': 3, 'is_immediate': 0},
    'XOR': {'opcode': "1100000000001100", 'number_of_operands': 3, 'is_immediate': 0},
    'OR': {'opcode': "1100000000001110", 'number_of_operands': 3, 'is_immediate': 0},
    'AND': {'opcode': "1100000000010000", 'number_of_operands': 3, 'is_immediate': 0},
}


def read_instruction_file():
    if len(sys.argv) < 2:
        print("please provide the path for the instructions file")
        sys.exit(1)
    instruction_path = sys.argv[1]
    with open(instruction_path, "r") as instruction_file:
        return instruction_file.read().splitlines()


def encode_assembly_line(instruction: str,lineNumber :int):
    tokenize_instruction = instruction.split()
    if tokenize_instruction[0] not in instructions_map:
        print("sorry we don't support that type of instruction yet")
        print(f"line of instruction --> {lineNumber} : {instruction}")

    return tokenize_instruction


if __name__ == "__main__":
    # Call the main function
    print(encode_assembly_line(read_instruction_file()[0],5))
