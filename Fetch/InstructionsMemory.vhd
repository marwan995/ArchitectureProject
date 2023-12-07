LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

ENTITY instructionMemory IS
    PORT (
        clk : IN STD_LOGIC;
        w_r : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY instructionMemory;

ARCHITECTURE Arch_instructionMemory OF instructionMemory IS
    TYPE instructionMemory_type IS ARRAY(0 TO 4096) OF STD_LOGIC_VECTOR(15 DOWNTO 0);

    FUNCTION load_memory_from_file(file_name: IN STRING) RETURN instructionMemory_type IS
    FILE file_string: TEXT OPEN READ_MODE IS file_name;
    VARIABLE line: LINE;
    VARIABLE bv: BIT_VECTOR(15 DOWNTO 0);
    VARIABLE memory: instructionMemory_type;
    VARIABLE idx: INTEGER := 0;
BEGIN
    WHILE idx < instructionMemory_type'LENGTH AND NOT ENDFILE(file_string) LOOP
        READLINE(file_string, line);
        READ(line, bv);
        memory(idx) := TO_STDLOGICVECTOR(bv);
        idx := idx + 1;
    END LOOP;

    RETURN memory;
END FUNCTION;

    SIGNAL instructionMemory : instructionMemory_type := load_memory_from_file("D:/3rd-cmp/First semster/Arch/project/Fetch/codes.txt") ;
BEGIN
    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            IF w_r = '1' THEN
                instructionMemory(to_integer(unsigned((address)))) <= datain;
            END IF;
        END IF;
    END PROCESS;
    dataout <= instructionMemory(to_integer(unsigned((address))));
END Arch_instructionMemory;