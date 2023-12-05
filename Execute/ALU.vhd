LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ALU IS
    PORT (
        enable : IN STD_LOGIC;
        a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        operationSel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

        result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        cout : OUT STD_LOGIC;
        flagReg : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ALU;

ARCHITECTURE ARCHALU OF ALU IS

    COMPONENT ALUNOT IS
        PORT (
            a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT ALUNOT;

    COMPONENT ALUOR IS
        PORT (
            a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT ALUOR;

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

    SIGNAL notOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL adderOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL adderCout : STD_LOGIC;
    SIGNAL orOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL adderOperationSel : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL adderCin : STD_LOGIC;

BEGIN

    AdderOperationSel <= "11" WHEN operationSel = "0100" -- dec
        ELSE
        "00";

    adderCin <= '0' WHEN operationSel = "0100" -- dec
        ELSE
        'Z'
        ;

    NotOperation : ALUNOT PORT MAP(a, notOutput);
    OrOperation : ALUOR PORT MAP(a, b, orOutput);
    AdderOperations : ALUADDER PORT MAP(a, b, adderCin, adderOperationSel, adderOutput, adderCout);

    result <= (OTHERS => '0') WHEN enable = '0'
        ELSE
        notOutput WHEN operationSel = "0001" -- not
        ELSE
        adderOutput WHEN operationSel = "0100" -- dec
        ELSE
        orOutput WHEN operationSel = "1100" -- or
        ELSE
        (OTHERS => 'Z');

END ARCHITECTURE;