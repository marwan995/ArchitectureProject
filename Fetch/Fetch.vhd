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

        instructionIn : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        instructionOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        immedateOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

        jumpPc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        memoryPc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        stackPc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
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

    SIGNAL instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL pcRegOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL pcRegIn : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL jmpMuxOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL pcMuxOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    ImmidateValue : Mux2 PORT MAP(
        instruction, (OTHERS => '0'), freeze, immedateOut
    );
    InstructionFreeze : Mux2 PORT MAP(
        instruction, instructionIn, freeze, instructionOut
    );
    -- ImmidateFlag :TFlipFlop port Map(

    -- );
    FetchInstruction : instructionMemory PORT MAP(
        clk, '0', pcRegOut(11 DOWNTO 0), ((OTHERS => '0')),
        instruction
    );

    ProgramCounter : REG GENERIC MAP(
        32) PORT MAP(
        clk, rst, pcRegIn, pcRegOut
    );
    pcOut <= pcRegOut;
    MemoryJump : Mux2 PORT MAP(
        jmpMuxOut, memoryPc, memoryPcFlag, instructionOut
    );

    Branch : Mux2 PORT MAP(
        pcMuxOut, jumpPc, jumpPcFlag, jmpMuxOut
    );
    --error update the pc
    stackJump : Mux2 PORT MAP(
        pcRegOut, stackPc, callRtiFlag, pcMuxOut
    );
END ARCHITECTURE;