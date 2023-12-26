LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ALU IS
    PORT (
        enable : IN STD_LOGIC;
        a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        flagRegBuffer : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

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

    COMPONENT RCR IS
        PORT (
            reg : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            amount : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            carry : IN STD_LOGIC;
            rotated : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            carryOut : OUT STD_LOGIC
        );
    END COMPONENT RCR;

    COMPONENT RCL IS
        PORT (
            reg : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            amount : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            carry : IN STD_LOGIC;
            rotated : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            carryOut : OUT STD_LOGIC
        );
    END COMPONENT RCL;

    COMPONENT BITSET IS
        PORT (
            a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            carryOut : OUT STD_LOGIC
        );
    END COMPONENT BITSET;

    SIGNAL notOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL adderOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL andOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL orOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL xorOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rcrOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rclOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL bitsetOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL adderCarryOut : STD_LOGIC;
    SIGNAL rcrCarryOut : STD_LOGIC;
    SIGNAL rclCarryOut : STD_LOGIC;
    SIGNAL bitsetCarryOut : STD_LOGIC;

    SIGNAL adderIn1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL adderCin : STD_LOGIC;
    SIGNAL adderOperationSel : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL resultTemp : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    -- 0001 not
    -- 0010 neg
    -- 0011 inc
    -- 0100 dec
    -- 0101 bitset
    -- 0110 RCL rotate left
    -- 0111 RCR rotate right
    -- 1000 cmp
    -- 1001 add
    -- 1010 sub
    -- 1011 and
    -- 1100 or
    -- 1101 xor

    NotOperation : ALUNOT PORT MAP(a, notOutput);
    RCROperation : RCR PORT MAP(a, b, flagRegBuffer(2), rcrOutput, rcrCarryOut);
    RCLOperation : RCL PORT MAP(a, b, flagRegBuffer(2), rclOutput, rclCarryOut);
    AndOperation : ALUAND PORT MAP(a, b, andOutput);
    OrOperation : ALUOR PORT MAP(a, b, orOutput);
    XorOperation : ALUXOR PORT MAP(a, b, xorOutput);
    BitSetOperation : BITSET PORT MAP(a, b, bitsetOutput, bitsetCarryOut);
    AdderOperations : ALUADDER PORT MAP(adderIn1, b, adderCin, adderOperationSel, adderOutput, adderCarryOut);

    AdderOperationSel <= "11" WHEN operationSel = "0100" -- dec
        ELSE
        "00" WHEN operationSel = "0011" OR operationSel = "0010" -- inc, neg
        ELSE
        "01" WHEN operationSel = "1001" -- add
        ELSE
        "10" WHEN operationSel = "1010" OR operationSel = "1000"-- sub, cmp
        ELSE
        "ZZ";

    adderCin <= '0' WHEN operationSel = "0100" -- dec
        ELSE
        '1' WHEN operationSel = "0011" OR operationSel = "0010" -- inc or neg
        ELSE
        '0' WHEN operationSel = "1001" -- add
        ELSE
        '1' WHEN operationSel = "1010" OR operationSel = "1000"-- sub, cmp
        ELSE
        'Z'
        ;

    adderIn1 <= NOT(a) WHEN operationSel = "0010" -- neg
        ELSE
        a
        ;

    -- result
    resultTemp <= (OTHERS => '0') WHEN enable = '0'
        ELSE
        notOutput WHEN operationSel = "0001" -- not
        ELSE
        adderOutput WHEN operationSel = "0100" OR operationSel = "0011" OR operationSel = "0010" OR operationSel = "1001" OR operationSel = "1010" OR operationSel = "1000"-- dec, inc, not, add, sub, cmp
        ELSE
        bitsetOutput WHEN operationSel = "0101" -- bitset
        ELSE
        andOutput WHEN operationSel = "1011" -- and
        ELSE
        orOutput WHEN operationSel = "1100" -- or
        ELSE
        xorOutput WHEN operationSel = "1101" -- xor
        ELSE
        rcrOutput WHEN operationSel = "0111" -- rcr
        ELSE
        rclOutput WHEN operationSel = "0110" -- rcl
        ELSE
        (OTHERS => 'Z');

    result <= resultTemp;

    -- negative flag
    flagReg(1) <= flagRegBuffer(1) WHEN enable = '0' -- not enabled
ELSE
    --     flagRegBuffer(1) WHEN operationSel = "0101" OR operationSel = "0110" OR operationSel = "0111" -- enabled with opeation that doesn't update negative flag
    -- ELSE
    resultTemp(31);

    -- carry flag
    flagReg(2) <= flagRegBuffer(2) WHEN enable = '0'
ELSE
    rcrCarryOut WHEN operationSel = "0111"
ELSE
    rclCarryOut WHEN operationSel = "0110"
ELSE
    bitsetCarryOut WHEN operationSel = "0101"
ELSE
    adderCarryOut WHEN operationSel = "0011" OR operationSel = "1001" -- inc, add-- till other is stated
ELSE
    '0'
    ;

    flagReg(0) <= flagRegBuffer(0) WHEN enable = '0' -- not enabled
ELSE
    --     flagRegBuffer(0) WHEN operationSel = "0101" OR operationSel = "0110" OR operationSel = "0111" -- enabled with opeation that doesn't update zero flag
    -- ELSE
    '1' WHEN resultTemp = "00000000000000000000000000000000"
ELSE
    '0'
    ;

    flagReg(3) <= '0';

END ARCHITECTURE;