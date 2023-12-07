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

ARCHITECTURE Arch_instructionMemory OF instructionMemory IS
    TYPE instructionMemory_type IS ARRAY(0 TO 4096) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL instructionMemory : instructionMemory_type := (
        -- "0000000000000000",
        -- "0000000000000000",
        -- "0100000000000000", -- not reg0
        -- "0000000000000000",
        -- "0000000000000000",
        -- "0100000000011000", -- dec
        -- "0000000000000000",
        -- "0000000000000000",

        -- "0100000001000000", -- out
        -- "0000000000000000",
        -- "0101100001100000", -- protect
        -- "0111100001000000", -- out reg7
        -- "0101100001100000", -- protect location at reg3
        -- "0100000001111001", -- load location 
        -- "0100000000011000", -- dec reg0
        -- "0000000000000000",
        -- "1111100000101110", -- or
        -- "0000000000000000",
        -- "0100000000011000", -- 
        -- "0100000001000000", -- out
        -- "1111100001101110", -- or
        OTHERS => (OTHERS => '0')
    );
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