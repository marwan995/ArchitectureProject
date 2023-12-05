LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY PipeLineReg IS
    GENERIC (n : INTEGER := 32);
    PORT (
        writeEnable : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        inData : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        outData : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
    );
END PipeLineReg;

ARCHITECTURE ArchPipeLineReg OF PipeLineReg IS
    SIGNAL reg : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
BEGIN
    PROCESS (writeEnable, rst)
    BEGIN
        IF rst = '1' THEN
            reg <= (OTHERS => '0');
        ELSIF rising_edge(writeEnable) THEN
                reg <= inData;

        END IF;
    END PROCESS;

    outData <= reg;
END ARCHITECTURE;