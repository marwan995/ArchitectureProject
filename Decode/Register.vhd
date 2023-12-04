LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY REG IS
    GENERIC (n : INTEGER := 32);
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        inData : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        outData : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
    );
END REG;

ARCHITECTURE ArchREG OF REG IS
    SIGNAL reg : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            reg <= (OTHERS => '0');
        ELSIF falling_edge(clk) then
            reg <= inData;

        END IF;
    END PROCESS;

    outData <= reg;
END ARCHITECTURE;