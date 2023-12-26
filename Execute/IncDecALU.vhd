LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY IncDecALU IS
    GENERIC (n : INTEGER := 32);
    PORT (
        enable : IN STD_LOGIC;
        inc : IN STD_LOGIC;

        a : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        incVal : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);

        result : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
    );
END IncDecALU;

ARCHITECTURE ArchIncDecALU OF IncDecALU IS

    COMPONENT ALUADDER IS
        GENERIC (n : INTEGER := 32);
        PORT (
            A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            CIN : IN STD_LOGIC;
            S : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            F : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            COUT : OUT STD_LOGIC
        );
    END COMPONENT ALUADDER;

    SIGNAL incDecSel : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL adderCin : STD_LOGIC;

BEGIN

    incDecSel <= "00" WHEN enable = '0'
        ELSE
        "01" WHEN inc = '1'
        ELSE
        "10" WHEN inc = '0'
        ;

    adderCin <= '0' WHEN enable = '0' ELSE
        NOT(inc);

    IncDecAdder : ALUADDER PORT MAP(a, incVal, adderCin, incDecSel, result);
END ARCHITECTURE;