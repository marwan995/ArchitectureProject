LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ALUADDER IS
    GENERIC (n : INTEGER := 32);
    PORT (
        A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        CIN : IN STD_LOGIC;
        S : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        F : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        COUT : OUT STD_LOGIC
    );
END ALUADDER;

ARCHITECTURE ArchALUADDER OF ALUADDER IS
    COMPONENT FullAdder IS
        GENERIC (
            n : INTEGER := 32
        );
        PORT (
            in1, in2 : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            carryIn : IN STD_LOGIC;
            sum : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            carryOut : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL result, temp : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    SIGNAL Carry : STD_LOGIC;
BEGIN
    temp <= (OTHERS => '0') WHEN ((s = "00"))
        ELSE
        (OTHERS => '1') WHEN ((s = "11") AND (CIN = '0'))
        ELSE
        NOT B WHEN (s(1) = '1')
        ELSE
        B;

    labeladdOne : Fulladder GENERIC MAP(n) PORT MAP(A, temp, cin, result, Carry);

    -- result
    f <= B WHEN (cin = '1' AND s = "11")
        ELSE
        result;

    -- carry out
    COUT <= '0' WHEN (s = "11" AND cin = '1')
        ELSE
        Carry;
END ARCHITECTURE;