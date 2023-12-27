LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY dataMemory IS
    PORT (
        clk : IN STD_LOGIC;
        w_r : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        rstData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY dataMemory;

ARCHITECTURE Arch_dataMemory OF dataMemory IS TYPE dataMemory_type
    IS ARRAY(0 TO 4096) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dataMemory : dataMemory_type := (
        -- "00000000000000000000000000011111",
        -- "01000000000000000100000000000011",
        OTHERS => (OTHERS => '0')
    );
BEGIN
    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            IF enable = '1' THEN
                IF w_r = '1' THEN
                    dataMemory(to_integer(unsigned((address)))) <= datain;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    dataout <= (OTHERS => 'Z') WHEN enable = '0' ELSE
        dataMemory(to_integer(unsigned((address))));
    rstData <= dataMemory(0);
END Arch_dataMemory;