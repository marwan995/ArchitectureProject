LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Mux1B IS
    PORT (
        a : IN STD_LOGIC;
        b : IN STD_LOGIC;
        selector : IN STD_LOGIC;
        output : OUT STD_LOGIC
    );
END Mux1B;

ARCHITECTURE ArchMux1B OF Mux1B IS

BEGIN
    output <= a WHEN selector = '0' ELSE
        b;

END ARCHITECTURE;