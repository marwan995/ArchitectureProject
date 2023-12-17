LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Mux4 IS
    GENERIC (n : INTEGER := 1);
    PORT (
        a : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        c : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        d : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        selector : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
    );
END Mux4;

ARCHITECTURE ArchMux4 OF Mux4 IS

BEGIN
    output <= a WHEN selector = "00" ELSE
        b WHEN selector = "01" ELSE
        c WHEN selector = "10" ELSE
        d;

END ARCHITECTURE;