LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY TriStateBuffer IS
    GENERIC (
        WIDTH : INTEGER := 32
    );
    PORT (
        enable : IN STD_LOGIC;
        input : IN STD_LOGIC_VECTOR(WIDTH - 1 DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR(WIDTH - 1 DOWNTO 0)
    );
END ENTITY TriStateBuffer;

ARCHITECTURE ArchTriStateBuffer OF TriStateBuffer IS
BEGIN
    output <= input WHEN enable = '1' ELSE
        (OTHERS => 'Z');
END ARCHITECTURE;