LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ALU IS
    PORT (
        enable : IN STD_LOGIC;
        a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        carryFlag : IN STD_LOGIC;

        operationSel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

        result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
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

    COMPONENT ALUAND IS
        PORT (
            a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT ALUAND;

    COMPONENT ALUXOR IS
        PORT (
            a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT ALUXOR;

    SIGNAL notOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL adderOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL andOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL orOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL xorOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL adderIn1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL adderCin : STD_LOGIC;
    SIGNAL adderOperationSel : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL resultTemp : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL flagRegBuffer : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";

BEGIN
    -- 0001 not
    -- 0010 neg
    -- 0011 inc
    -- 0100 dec
    -- 0110 RCL rotate left
    -- 0111 RCR rotate right
    -- 1001 add
    -- 1010 sub
    -- 1011 and
    -- 1100 or
    -- 1101 xor

    NotOperation : ALUNOT PORT MAP(a, notOutput);
    RCROperation : RCR
    AndOperation : ALUAND PORT MAP(a, b, andOutput);
    OrOperation : ALUOR PORT MAP(a, b, orOutput);
    XorOperation : ALUXOR PORT MAP(a, b, xorOutput);
    AdderOperations : ALUADDER PORT MAP(adderIn1, b, adderCin, adderOperationSel, adderOutput, flagRegBuffer(2));

    AdderOperationSel <= "11" WHEN operationSel = "0100" -- dec
        ELSE
        "00" WHEN operationSel = "0011" OR operationSel = "0010" -- inc, neg
        ELSE
        "01" WHEN operationSel = "1001" -- add
        ELSE
        "10" WHEN operationSel = "1010" -- sub
        ELSE
        "ZZ";

    adderCin <= '0' WHEN operationSel = "0100" -- dec
        ELSE
        '1' WHEN operationSel = "0011" OR operationSel = "0010" -- inc or neg
        ELSE
        '0' WHEN operationSel = "1001" -- add
        ELSE
        '1' WHEN operationSel = "1010" -- sub
        ELSE
        'Z'
        ;

    adderIn1 <= NOT(a) WHEN operationSel = "0010" -- neg
        ELSE
        a
        ;
    resultTemp <= (OTHERS => '0') WHEN enable = '0'
        ELSE
        notOutput WHEN operationSel = "0001" -- not
        ELSE
        adderOutput WHEN operationSel = "0100" OR operationSel = "0011" OR operationSel = "0010" OR operationSel = "1001" OR operationSel = "1010" -- dec, inc, not, add, sub
        ELSE
        andOutput WHEN operationSel = "1011" -- and
        ELSE
        orOutput WHEN operationSel = "1100" -- or
        ELSE
        xorOutput WHEN operationSel = "1101" -- xor
        ELSE
        (OTHERS => 'Z');

    result <= resultTemp;

    flagReg <= flagRegBuffer WHEN enable = '0'
        ELSE
        (flagRegBuffer(3 DOWNTO 1) & '1') WHEN
        resultTemp = "00000000000000000000000000000000"
        ELSE
        (OTHERS => '0');

END ARCHITECTURE;