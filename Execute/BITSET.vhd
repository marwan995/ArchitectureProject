LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY BITSET IS
    PORT (
        a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        carryOut : OUT STD_LOGIC
    );
END BITSET;

ARCHITECTURE archBITSET OF BITSET IS
    SIGNAL bit_num : INTEGER RANGE 0 TO 31;
BEGIN
    bit_num <= to_integer(unsigned(b(4 DOWNTO 0)));
    carryOut <= a(bit_num);

    result <= a(31 DOWNTO 1) & '1' WHEN bit_num = 0
        ELSE
        '1' & a(30 DOWNTO 0) WHEN bit_num = 31
        ELSE
        a(31 DOWNTO bit_num + 1) & '1' & a(bit_num - 1 DOWNTO 0);

END ARCHITECTURE;