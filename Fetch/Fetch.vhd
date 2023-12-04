LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Fetch IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        freeze : IN STD_LOGIC;
        callRtiFlag : IN STD_LOGIC;
        memoryPcFlag : IN STD_LOGIC;
        jumpPcFlag : IN STD_LOGIC;
        assemblerWR : IN STD_LOGIC;
        immedateFlag : OUT STD_LOGIC;

        instructionIn : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        assemblerInstruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        instructionOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        immedateOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

        jumpPc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        memoryPc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        stackPc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        assemblerPC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        pcOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END Fetch;

ARCHITECTURE ArchFetch OF Fetch IS
    COMPONENT instructionMemory IS
        PORT (
            clk : IN STD_LOGIC;
            w_r : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
    END COMPONENT instructionMemory;

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
    COMPONENT Mux2 IS
        GENERIC (n : INTEGER := 16);
        PORT (
            a : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            selector : IN STD_LOGIC;
            output : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT Mux2;
    COMPONENT TFlipFlop IS
        PORT (
            t, rst, preset, clk : IN STD_LOGIC;
            q, qbar : OUT STD_LOGIC
        );
    END COMPONENT TFlipFlop;
    COMPONENT FullAdder IS
        GENERIC (n : INTEGER := 8);
        PORT (
            in1, in2 : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            carryIn : IN STD_LOGIC;
            sum : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            carryOut : OUT STD_LOGIC);
    END COMPONENT FullAdder;

    SIGNAL instruction2Read : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL InstructionMuxOut : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL instruction2ReadAddress : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL pcRegOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL pcRegIn : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL jmpMuxOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL pcMuxOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL updatedPc : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN

    ImmidateValue : Mux2 PORT MAP(
    (OTHERS => '0'), instruction, freeze, immedateOut
    );
    InstructionFreeze : Mux2 PORT MAP(
        instruction, instructionIn, freeze, instructionMuxOut
    );

    instructionOut <= instructionMuxOut;

    ImmidateFlag : TFlipFlop PORT MAP(
        instructionMuxOut(0), rst, '0', clk, immedateFlag, OPEN
    );

    InstructionsMemoryPC : Mux2 GENERIC MAP(
        32) PORT MAP(
        pcRegOut, assemblerPc, assemblerWR, instruction2ReadAddress
    );

    FetchInstruction : instructionMemory PORT MAP(
        clk, assemblerWR, instruction2ReadAddress(11 DOWNTO 0), assemblerInstruction,
        instruction
    );

    ProgramCounter : REG GENERIC MAP(
        32) PORT MAP(
        clk, '1', rst, pcRegIn, pcRegOut
    );

    pcOut <= pcRegOut;
    incrementPc : FullAdder GENERIC MAP(
        32) PORT MAP (
        pcRegOut, (OTHERS => '0'), '1', updatedPc, OPEN
    );
    MemoryJump : Mux2 GENERIC MAP(
        32) PORT MAP(
        jmpMuxOut, memoryPc, memoryPcFlag, pcRegIn
    );

    Branch : Mux2 GENERIC MAP(
        32) PORT MAP(
        pcMuxOut, jumpPc, jumpPcFlag, jmpMuxOut
    );

    stackJump : Mux2 GENERIC MAP(
        32) PORT MAP(
        updatedPc, stackPc, callRtiFlag, pcMuxOut
    );
END ARCHITECTURE;