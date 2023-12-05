LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY IO IS
    PORT (
        clk : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        I_O : IN STD_LOGIC; -- 0 input 1 output

        InputPort : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- in from CPU
        RegVal : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- value from last stage

        OutputPort : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); -- out to CPU
        IO2WB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END IO;

ARCHITECTURE ArchIO OF IO IS
    COMPONENT REG IS
        GENERIC (n : INTEGER := 32);
        PORT (
            clk : IN STD_LOGIC;
            en : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            inData : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            outData : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT REG;

    SIGNAL inEnable : STD_LOGIC;
    SIGNAL outEnable : STD_LOGIC;

BEGIN

    inEnable <= enable AND NOT(I_O);
    outEnable <= enable AND I_O;

    inputLatch : REG PORT MAP(clk, inEnable, rst, InputPort, IO2WB);
    outputLatch : REG PORT MAP(clk, outEnable, rst, regVal, OutputPort);

END ARCHITECTURE;