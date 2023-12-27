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
        reg1Value : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        flagsIn : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        flagsOut : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        pc : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        flagSelector : IN STD_LOGIC;

        --IO
        inputPort : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        outputPort : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

        memoryOut : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        protectionFlag : OUT STD_LOGIC;
        stackPointerOutput : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        rstData : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)

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

    COMPONENT stackReg IS
        PORT (
            clk : IN STD_LOGIC;
            en : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            inData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            outData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT stackReg;

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
    COMPONENT IncDecALU IS
        GENERIC (n : INTEGER := 32);
        PORT (
            enable : IN STD_LOGIC;
            inc : IN STD_LOGIC;

            a : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            incVal : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);

            result : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT IncDecALU;
    COMPONENT dataMemory IS
        PORT (
            clk : IN STD_LOGIC;
            w_r : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            rstData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT dataMemory;
    COMPONENT protectedMemory IS
        PORT (
            clk : IN STD_LOGIC;
            w_r : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            protectedin : IN STD_LOGIC;
            protectedout : OUT STD_LOGIC);
    END COMPONENT protectedMemory;

    COMPONENT IO IS
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
    END COMPONENT IO;

    COMPONENT Mux1B IS
        PORT (
            a : IN STD_LOGIC;
            b : IN STD_LOGIC;
            selector : IN STD_LOGIC;
            output : OUT STD_LOGIC
        );
    END COMPONENT Mux1B;

    SIGNAL StackPointerIn : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000111111111111";
    SIGNAL StackPointerTemp : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000111111111111";
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
    SIGNAL memoryDataOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memoryProtectOut : STD_LOGIC;
    SIGNAL flagsOrPcPlus1Selector : STD_LOGIC;
    SIGNAL instructionFreeCondation : STD_LOGIC;

    SIGNAL IO2WriteBack : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memoryOutTemp : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL isProtected : STD_LOGIC;
    SIGNAL initial_value : STD_LOGIC_VECTOR(31 DOWNTO 0);
    --   SIGNAL flagSelector : STD_LOGIC;
    SIGNAL dataMemoryWR : STD_LOGIC;
    SIGNAL dataMemoryEnable : STD_LOGIC;
    SIGNAL protectedMemoryDataIn : STD_LOGIC;
    SIGNAL IoEnable : STD_LOGIC;
    SIGNAL notClk : STD_LOGIC;
    SIGNAL stackRegClk : STD_LOGIC;

BEGIN
    notClk <= NOT(clk);

    stackPointerMux : Mux1B PORT MAP(
        notClk, clk, instruction(3), stackRegClk
    );

    ---------------StackPointer -----------------------------
    StackPointerOutput <= memoryAddress;

    StackPointer : stackReg PORT MAP(
        notClk, MemorySignals(3), rst, StackPointerTemp, StackPointerIn
    );
    changeSp : IncDecALU GENERIC MAP(32) PORT MAP(MemorySignals(3), MemorySignals(2), StackPointerIn, "00000000000000000000000000000010", StackPointerTemp);
    ---------------increment -----------------------------

    SpPlusTwo : FullAdder GENERIC MAP(
        32)PORT MAP (
        StackPointerOut, "00000000000000000000000000000010", '0', StackPointerPlus2, OPEN
    );
    SpPlusFour : FullAdder GENERIC MAP(
        32)PORT MAP (
        StackPointerOut, "00000000000000000000000000000100", '0', StackPointerPlus4, OPEN
    );
    ---------------Address -----------------------------

    -- incrementSpWithValue : Mux2 GENERIC MAP(
    --     32) PORT MAP(--stopflag
    --     StackPointerPlus2, StackPointerPlus4, MemorySignals(0), incrementSpWithValueOut
    -- );
    -- pickSpOrSpUpdated : Mux2 GENERIC MAP(
    --     32) PORT MAP(--ask seif 
    --     StackPointerIn, incrementSpWithValueOut, MemorySignals(0), SpOrUpdatedSpOut
    -- );
    RegOrStackPointer : Mux2 GENERIC MAP(
        32) PORT MAP(
        reg1Value, StackPointerIn, instruction(4), RegOrStackOut
    );
    memoryAddressMux : Mux2 GENERIC MAP(
        32) PORT MAP(
        RegOrStackOut, immedate, instruction(0), memoryAddress
    );
    ---------------MemoryValue -----------------------------
    incrementPc : FullAdder GENERIC MAP(
        32) PORT MAP (
        pc, (OTHERS => '0'), '1', PcPlus1, OPEN
    );

    initial_value <= "0000000000000000000000000000" & flagsIn;

    flagsOrPcPlus1 : Mux2 GENERIC MAP(
        32) PORT MAP(
        PcPlus1, initial_value, MemorySignals(0), flagsOrPcPlus1Out
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
    -- flagSelector <= (NOT (memorySignals(6)) AND memorySignals(0));

    flags : Mux2 GENERIC MAP(
        4) PORT MAP(
        flagsin, memoryOutTemp(3 DOWNTO 0), flagSelector, flagsout
    );
    ---------------Memories -----------------------------
    isProtected <= ((memoryProtectOut NOR MemorySignals(1)) OR (MemorySignals(1) AND instruction(3)));

    dataMemoryEnable <= (MemorySignals(8) AND NOT MemorySignals(7) AND (NOT (MemorySignals(1)) OR instruction(3)));
    dataMemoryWR <= MemorySignals(6) AND isProtected;

    data : dataMemory PORT MAP(
        clk, dataMemoryWR, dataMemoryEnable, memoryAddress(11 DOWNTO 0), memoryValueOut, memoryDataOut, rstData
    );
    protectedMemoryDataIn <= NOT instruction(3);

    protectedMemo : protectedMemory PORT MAP(
        clk, MemorySignals(1), MemorySignals(8), memoryAddress(11 DOWNTO 0), protectedMemoryDataIn, memoryProtectOut
    );

    protectionFlag <= memoryProtectOut;

    ---------------I/O -----------------------------
    IoEnable <= (MemorySignals(8) AND MemorySignals(7));

    I_O : IO PORT MAP(
        clk,
        IoEnable,
        rst,
        MemorySignals(6),
        inputPort,
        reg1Value,
        outputPort,
        IO2WriteBack);

    ---------------pick memroy Out -----------------------------
    memoryResult : Mux2 GENERIC MAP(
        32) PORT MAP(
        memoryDataOut, IO2WriteBack, MemorySignals(7), memoryOutTemp
    );
    memoryOut <= memoryOutTemp;

END ARCHITECTURE;