LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY WriteBack IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        instruction : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        writeBackSignals : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        immedate : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        alu : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        memory : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        reg1Value : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        reg2Value : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

        writeBack1Enable : OUT STD_LOGIC;
        writeBack2Enable : OUT STD_LOGIC;
        writeBack1Address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        writeBack2Address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        writeBack1Data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        writeBack2Data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        memoryPc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    );
END WriteBack;

ARCHITECTURE rtl OF WriteBack IS
    COMPONENT Mux2 IS
        GENERIC (n : INTEGER := 16);
        PORT (
            a : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            selector : IN STD_LOGIC;
            output : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT Mux2;
    SIGNAL regOrAluOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL immedateOrmemoryOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Mux4ValueOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memorySelector : STD_LOGIC;

BEGIN
    regOrAlu : Mux2 GENERIC MAP(
        32) PORT MAP(
        reg1Value, alu, writeBackSignals(0), regOrAluOut
    );
    immedateOrmemory : Mux2 GENERIC MAP(
        32) PORT MAP(
        memory, immedate, writeBackSignals(0), immedateOrmemoryOut
    );
    Mux4Value : Mux2 GENERIC MAP(
        32) PORT MAP(
        regOrAluOut, immedateOrmemoryOut, writeBackSignals(1), Mux4ValueOut
    );
    writeBack1Value : Mux2 GENERIC MAP(
        32) PORT MAP(
        Mux4ValueOut, reg2Value, writeBackSignals(2), writeBack1Data
    );
    ---- writeBackEnable 
    writeBack1Enable <= writeBackSignals(3);
    writeBack2Enable <= writeBackSignals(2);
    ----- writeBackData
    writeBack1Address <= instruction(13 DOWNTO 11);
    writeBack2Address <= instruction(10 DOWNTO 8);
    --- memory
    memorySelector <= (instruction(1) xor instruction(2));
    memoryPcUpdate : Mux2 GENERIC MAP(
        32) PORT MAP(
        reg1Value, memory, memorySelector, memoryPc
    );
    ---- writeBack2Data
    writeBack2Data <= reg2Value; 

END ARCHITECTURE;