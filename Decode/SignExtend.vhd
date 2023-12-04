LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY SignExtend IS
    PORT (
        inVector : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        outVector : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY SignExtend;

ARCHITECTURE ArchSignExtend OF SignExtend IS
BEGIN
    outVector(31 DOWNTO 16) <= (OTHERS => '1') WHEN inVector(15) = '1' 
    ELSE (OTHERS => '0');
    outVector(15 DOWNTO 0) <= inVector;
END ARCHITECTURE;