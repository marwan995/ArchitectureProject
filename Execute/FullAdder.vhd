LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FullAdder IS
    GENERIC (n : INTEGER := 8);
    PORT (
        in1, in2 : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        carryIn : IN STD_LOGIC;
        sum : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        carryOut : OUT STD_LOGIC);
END FullAdder;

ARCHITECTURE ArchFullAdder OF FullAdder IS
    COMPONENT BitAdder IS
        PORT (
            a, b, cin : IN STD_LOGIC;
            s, cout : OUT STD_LOGIC
        );
    END COMPONENT;
    SIGNAL temp : STD_LOGIC_VECTOR(n DOWNTO 0);
BEGIN
    temp(0) <= carryIn;
    loop1 : FOR i IN 0 TO n - 1 GENERATE
        fx : BitAdder PORT MAP(in1(i), in2(i), temp(i), sum(i), temp(i + 1));
    END GENERATE;
    carryOut <= temp(n);
END ArchFullAdder;