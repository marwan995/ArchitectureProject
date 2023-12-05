LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Memory IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        instruction : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        MemorySignals : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
        immedate : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        alu : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        memory : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        reg1Value : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        flagsIn : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        flagsOut : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        pc : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        memoryOut : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)

    );
END Memory;

ARCHITECTURE ArchMemory OF Memory IS
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
    COMPONENT FullAdder IS
        GENERIC (n : INTEGER := 8);
        PORT (
            in1, in2 : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            carryIn : IN STD_LOGIC;
            sum : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            carryOut : OUT STD_LOGIC);
    END COMPONENT FullAdder;
    SIGNAL StackPointerIn : STD_LOGIC_VECTOR(31 DOWNTO 0):="00000000000000000000111111111111";
    SIGNAL StackPointerOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL StackPointerPlus4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL StackPointerPlus2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL incrementSpWithValueOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL SpOrUpdatedSpOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL RegOrStackOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memoryAddress : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PcPlus1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL flagsOrPcPlus1Out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL callOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memoryValueOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL flagsOrPcPlus1Selector : STD_LOGIC;
    SIGNAL instructionFreeCondation : STD_LOGIC;
BEGIN

    ---------------StackPointer -----------------------------

    StackPointer : REG GENERIC MAP(
        32) PORT MAP(
        clk, MemorySignals(3), rst, StackPointerIn, StackPointerOut
    );


    ---------------increment -----------------------------

    SpPlusTwo : FullAdder GENERIC MAP(
        32)PORT MAP (
        StackPointerOut, "0000000000000010", '0', StackPointerPlus2, OPEN
    );
    SpPlusFour : FullAdder GENERIC MAP(
        32)PORT MAP (
        StackPointerOut, "0000000000000100", '0', StackPointerPlus4, OPEN
    );
    ---------------Address -----------------------------

    incrementSpWithValue : Mux2 GENERIC MAP(
        32) PORT MAP(--stopflag
        StackPointerPlus2, StackPointerPlus4, MemorySignals(0), incrementSpWithValueOut
    );
    pickSpOrSpUpdated : Mux2 GENERIC MAP(
        32) PORT MAP(--ask seif 
        StackPointerOut, incrementSpWithValueOut, MemorySignals(0), SpOrUpdatedSpOut
    );
    RegOrStackPointer : Mux2 GENERIC MAP(
        32) PORT MAP(
        reg1Value, SpOrUpdatedSpOut, instruction(4), RegOrStackOut
    );
    memoryAddressMux : Mux2 GENERIC MAP(
        32) PORT MAP(
        SpOrUpdatedSpOut, immedate, instruction(0), memoryAddress
    );
    ---------------MemoryValue -----------------------------
    incrementPc : FullAdder GENERIC MAP(
        32) PORT MAP (
        pc, (OTHERS => '0'), '1', PcPlus1, OPEN
    );
    flagsOrPcPlus1 : Mux2 GENERIC MAP(
        32) PORT MAP(
        PcPlus1, "0000000000000000000000000000" & flagsIn, MemorySignals(0), flagsOrPcPlus1Out
    );

    flagsOrPcPlus1Selector <= (NOT instruction(15) AND (instruction(1) AND instruction(2)));
    callJmp : Mux2 GENERIC MAP(
        32) PORT MAP(
        reg1Value, flagsOrPcPlus1Out, flagsOrPcPlus1Selector, callOut
    );
    instructionFreeCondation <= (memorySignals(1) AND instruction(3));
    memoryValue : Mux2 GENERIC MAP(
        32) PORT MAP(
        callOut, (OTHERS => '0'), instructionFreeCondation, memoryValueOut
    );
    ---------------Flags -----------------------------
    flags : Mux2 GENERIC MAP(
        32) PORT MAP(
            flagsin,memory(3 downto 0),(not (memorySignals(6)) and memorySignals(0) ),flagsout
    );


END ARCHITECTURE;