LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Execute IS
    PORT (
        clk : IN STD_LOGIC;
        aluEnable : IN STD_LOGIC;
        immediate : IN STD_LOGIC;
        src1Sel : IN STD_LOGIC;

        src1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        src2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        immediateVal : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        flagReg : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        ALUOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALUCarryOut : OUT STD_LOGIC
    );
END Execute;

ARCHITECTURE ArchExecute OF Execute IS
    COMPONENT Mux2 IS
        GENERIC (n : INTEGER := 32);
        PORT (
            a : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            selector : IN STD_LOGIC;
            output : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT Mux2;
BEGIN

END ARCHITECTURE;