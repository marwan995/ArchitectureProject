LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Mux2 IS
    GENERIC (n : INTEGER := 1);
    PORT (
        a : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        selector : IN STD_LOGIC;
        output : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
    );
END Mux2;

ARCHITECTURE ArchMux2 OF Mux2 IS

BEGIN
    output <= a WHEN selector = '0' ELSE
        b;

END ARCHITECTURE;