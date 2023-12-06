LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testBench IS
    PORT (
        clk : OUT STD_LOGIC;
        rst : IN STD_LOGIC;
        instructionPC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        writeInstructionEnable : IN STD_LOGIC;
        instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        inputPort : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        currentInstruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

        pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        outputPort : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        memoryOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        flags : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

        register0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register5 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register6 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register7 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END testBench;

ARCHITECTURE archTestBench OF testBench IS

    COMPONENT Processor IS
        PORT (
            clk : OUT STD_LOGIC;
            rst : IN STD_LOGIC;
            inputPort : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            assemblerWR : IN STD_LOGIC;
            assemblerInstruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            assemblerPC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            currentInstruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

            inttrupt : IN STD_LOGIC;
            outPort : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            memoryOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            pcOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            flags : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

            register0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register5 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register6 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register7 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT Processor;
BEGIN

    MIPS : Processor PORT MAP(
        clk,
        rst,
        inputPort,
        writeInstructionEnable,
        instruction,
        instructionPc,
        currentInstruction,
        '0',
        outputPort,
        memoryOut,
        pc,
        flags,
        register0,
        register1,
        register2,
        register3,
        register4,
        register5,
        register6,
        register7
    );

END ARCHITECTURE;