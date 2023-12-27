LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Pc IS
    PORT (
        clk : IN STD_LOGIC;
        en : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        inData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        rstData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        outData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END Pc;

ARCHITECTURE ArchPc OF Pc IS
    SIGNAL reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            reg <= rstData;
        ELSIF falling_edge(clk) THEN
            IF en = '1' THEN
                reg <= inData;

            END IF;
        END IF;
    END PROCESS;

    outData <= reg;
END ARCHITECTURE;