LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RegDecode IS
    PORT (
        regNum : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        bufferNum : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END RegDecode;

ARCHITECTURE ArchRegDecode OF RegDecode IS

BEGIN

    bufferNum <=
        "00000001" WHEN regNum = "000"
        ELSE
        "00000010" WHEN regNum = "001"
        ELSE
        "00000100" WHEN regNum = "010"
        ELSE
        "00001000" WHEN regNum = "011"
        ELSE
        "00010000" WHEN regNum = "100"
        ELSE
        "00100000" WHEN regNum = "101"
        ELSE
        "01000000" WHEN regNum = "110"
        ELSE
        "10000000" WHEN regNum = "111";
END ARCHITECTURE;