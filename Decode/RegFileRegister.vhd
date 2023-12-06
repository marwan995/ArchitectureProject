LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RegFileREG IS
    GENERIC (n : INTEGER := 32);
    PORT (
        clk : IN STD_LOGIC;
        en : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        inData : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        outData : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
    );
END RegFileREG;

ARCHITECTURE ArchRegFileREG OF RegFileREG IS
    SIGNAL reg : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
BEGIN

    PROCESS (clk, en, rst)
    BEGIN
        IF rst = '1' THEN
            reg <= (OTHERS => '0');
        ELSIF en = '1' THEN
            IF falling_edge(clk) THEN
                reg <= inData;

            END IF;
        END IF;
    END PROCESS;

    outData <= reg;
END ARCHITECTURE;