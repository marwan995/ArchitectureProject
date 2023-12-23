LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Execute IS
    PORT (
        clk : IN STD_LOGIC;
        aluEnable : IN STD_LOGIC;
        immediate : IN STD_LOGIC;
        src1Sel : IN STD_LOGIC;
        src2Sel : IN STD_LOGIC;
        src3Sel : IN STD_LOGIC; -- should be removed (not used)
        flagRegBuffer : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        operationSel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        src1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        src2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        immediateVal : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        flagReg : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        ALUOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END Execute;

ARCHITECTURE ArchExecute OF Execute IS

    COMPONENT ALU IS
        PORT (
            enable : IN STD_LOGIC;
            a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            flagRegBuffer : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            operationSel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

            result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            flagReg : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT ALU;

    COMPONENT Mux2 IS
        GENERIC (n : INTEGER := 32);
        PORT (
            a : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            selector : IN STD_LOGIC;
            output : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT Mux2;

    SIGNAL bIn : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    bMux : Mux2 GENERIC MAP(32) PORT MAP(src2, immediateVal, src2Sel, bIn);

    executeALU : ALU PORT MAP(aluEnable, src1, bIn, flagRegBuffer, operationSel, ALUout, flagReg);

END ARCHITECTURE;