LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ALUNOT IS
    PORT (
        a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ALUNOT;

ARCHITECTURE ArchALUNOT OF ALUNOT IS
BEGIN

    result <= NOT a;

END ARCHITECTURE;