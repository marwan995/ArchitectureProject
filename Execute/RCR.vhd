LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RCR IS
    PORT (
        reg : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        amount : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        carry : IN STD_LOGIC;
        rotated : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        carryOut : OUT STD_LOGIC
    );
END ENTITY RCR;

ARCHITECTURE ArchRCR OF RCR IS
    SIGNAL amount_int : INTEGER RANGE 0 TO 31;
    SIGNAL to_rotate : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL rotated_vector : STD_LOGIC_VECTOR(32 DOWNTO 0);
BEGIN
    to_rotate <= reg & carry;
    amount_int <= to_integer(unsigned(amount));

    rotated_vector <= (OTHERS => '0') WHEN amount_int = 0
        ELSE
        to_rotate(amount_int - 1 DOWNTO 0) & reg(31 DOWNTO amount_int);

    rotated <= rotated_vector(32 DOWNTO 1);
    carryOut <= rotated_vector(0);
END ARCHITECTURE ArchRCR;