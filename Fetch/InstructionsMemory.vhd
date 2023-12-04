LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY instructionMemory IS
    PORT (
        clk : IN STD_LOGIC;
        w_r : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY instructionMemory;

ARCHITECTURE Arch_instructionMemory OF instructionMemory IS TYPE instructionMemory_type 
IS ARRAY(0 TO 4096) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL instructionMemory : instructionMemory_type;
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