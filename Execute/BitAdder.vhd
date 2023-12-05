LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY BitAdder IS
    PORT (
        a, b, cin : IN STD_LOGIC;
        s, cout : OUT STD_LOGIC
    );
END BitAdder;

ARCHITECTURE ArchBitAdder OF BitAdder IS

BEGIN
    s <= a XOR b XOR cin;
    cout <= (a AND b) OR (cin AND (a XOR b));
END ARCHITECTURE;