LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Processor IS
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
        protectFlag : OUT STD_LOGIC;

        register0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register5 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register6 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register7 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        stackPointer : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END Processor;

ARCHITECTURE ArchProcessor OF Processor IS
    COMPONENT Fetch IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
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
            pcOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            rstInData : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT Fetch;
    COMPONENT Decode IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            freeze : IN STD_LOGIC;
            instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            immedateValue : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            writeBack1Enable : IN STD_LOGIC;
            writeBack2Enable : IN STD_LOGIC;

            writeBack1Address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            writeBack2Address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

            writeBack1Data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            writeBack2Data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            reg1Value : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            reg2Value : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            immedateValueExtended : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            writeBack : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            memory : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
            alu : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            jmpFlag : OUT STD_LOGIC;

            register0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register5 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register6 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register7 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

        );
    END COMPONENT Decode;
    COMPONENT Execute IS
        PORT (
            clk : IN STD_LOGIC;
            aluEnable : IN STD_LOGIC;
            immediate : IN STD_LOGIC;
            src1Sel : IN STD_LOGIC;
            src2Sel : IN STD_LOGIC;
            src3Sel : IN STD_LOGIC;
            flagRegBuffer : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            operationSel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            src1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            src2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            immediateVal : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            flagReg : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            ALUOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT Execute;
    COMPONENT Memory IS
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
    END COMPONENT Memory;
    COMPONENT WriteBack IS
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
    END COMPONENT WriteBack;

    COMPONENT Mux2 IS
        GENERIC (n : INTEGER := 1);
        PORT (
            a : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            selector : IN STD_LOGIC;
            output : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT Mux2;

    COMPONENT PipeLineReg IS
        GENERIC (n : INTEGER := 32);
        PORT (
            writeEnable : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            inData : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            outData : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT PipeLineReg;

    SIGNAL clock : STD_LOGIC := '1';
    SIGNAL flagRegSelector : STD_LOGIC := '0';
    SIGNAL ALUFlagOut : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL MemoryFlagOut : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL aluEnable : std_logic;

    SIGNAL IF_ID_input : STD_LOGIC_VECTOR(64 DOWNTO 0) := (OTHERS => '0');
    SIGNAL IF_ID_output : STD_LOGIC_VECTOR(64 DOWNTO 0) := (OTHERS => '0');

    SIGNAL ID_EX_input : STD_LOGIC_VECTOR(165 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ID_EX_output : STD_LOGIC_VECTOR(165 DOWNTO 0) := (OTHERS => '0');

    SIGNAL EX_MEM_input : STD_LOGIC_VECTOR(193 DOWNTO 0) := (OTHERS => '0');
    SIGNAL EX_MEM_output : STD_LOGIC_VECTOR(193 DOWNTO 0) := (OTHERS => '0');

    SIGNAL MEM_WB_input : STD_LOGIC_VECTOR(211 DOWNTO 0) := (OTHERS => '0');
    SIGNAL MEM_WB_output : STD_LOGIC_VECTOR(211 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rstSignal : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- WR outputs
    SIGNAL writeBack1EnableSig : STD_LOGIC;
    SIGNAL writeBack2EnableSig : STD_LOGIC;
    SIGNAL writeBack1AddressSig : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL writeBack2AddressSig : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL writeBack1DataSig : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL writeBack2DataSig : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memoryPcSig : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL jmpAndJz : STD_LOGIC;
    SIGNAL notClk : STD_LOGIC;

BEGIN
    PROCESS
    BEGIN
        WAIT FOR 50 ns;
        clock <= NOT clock;
    END PROCESS;

    clk <= clock;

    notClk <= NOT(clock);

    pcOut <= IF_ID_output(64 DOWNTO 33);
    currentInstruction <= IF_ID_input(31 DOWNTO 16);
    flags <= EX_MEM_output(193 DOWNTO 190);
    memoryOut <= MEM_WB_output(95 DOWNTO 64);

    ----------------- Fetching -----------------------------

    Fetching : Fetch PORT MAP(
        clock,
        rst,
        '0',
        '0',
        ID_EX_output(117),
        assemblerWR,
        IF_ID_input(32),
        IF_ID_input(31 DOWNTO 16),
        assemblerInstruction,
        IF_ID_input(31 DOWNTO 16),
        IF_ID_input(15 DOWNTO 0),
        ID_EX_output (31 DOWNTO 0),
        memoryPcSig,
        (OTHERS => '0'),
        assemblerPC,
        IF_ID_input(64 DOWNTO 33),
        rstSignal
    );

    -- 15 : 0  immidate ,  31 :16 instruction , 32 freeze(imm) , 64 :33 PC 
    IF_ID : PipeLineReg GENERIC MAP(
        65) PORT MAP(
        notclk, rst, IF_ID_input, IF_ID_output
    );

    ----------------- Decoding ----------------------------

    Decoding : Decode PORT MAP(
        clock,
        rst,
        IF_ID_output(32),
        IF_ID_output(31 DOWNTO 16),
        IF_ID_output(15 DOWNTO 0),
        writeBack1EnableSig,
        writeBack2EnableSig,
        writeBack1AddressSig,
        writeBack2AddressSig,
        writeBack1DataSig,
        writeBack2DataSig,

        ID_EX_input(31 DOWNTO 0),
        ID_EX_input(63 DOWNTO 32),
        ID_EX_input(95 DOWNTO 64),
        ID_EX_input(99 DOWNTO 96),
        ID_EX_input(108 DOWNTO 100),
        ID_EX_input(116 DOWNTO 109),
        jmpAndJz,

        register0,
        register1,
        register2,
        register3,
        register4,
        register5,
        register6,
        register7
    );
    ID_EX_input(117) <= jmpAndJz AND (NOT IF_ID_output(17) OR EX_MEM_input(190));
    -- forward instruction
    ID_EX_input(133 DOWNTO 118) <= IF_ID_output(31 DOWNTO 16);

    -- forward pc
    ID_EX_input(165 DOWNTO 134) <= IF_ID_output(64 DOWNTO 33);

    -- 31:0 src1,       63:32 src2,     95:64 immediate(sign extended),
    -- 99:96 WB,       108:100 MEM,    116:109 ALU,    117 jmpFlag
    -- 133:118 instruction,      165:134 pc
    ID_EX : pipeLineReg GENERIC MAP(
        166) PORT MAP(
        clock, rst, ID_EX_input, ID_EX_output
    );

    ----------------- Execute ----------------------------

    aluEnable <= '0' WHEN ID_EX_output(97) = '1' and ID_EX_output(116) = '1' and ID_EX_output(112 downto 109) = "0001"
    else
    ID_EX_output(116);

    Executing : Execute PORT MAP(
        clock,
        aluEnable,
        ID_EX_output(118),
        ID_EX_output(115),
        ID_EX_output(114),
        ID_EX_output(113),
        EX_MEM_output(193 DOWNTO 190),
        ID_EX_output(112 DOWNTO 109),
        ID_EX_output(31 DOWNTO 0),
        ID_EX_output(63 DOWNTO 32),
        ID_EX_output(95 DOWNTO 64),

        ALUFlagOut,
        EX_MEM_input(95 DOWNTO 64)
    );

    flagRegSelector <= NOT (ID_EX_output(106)) AND ID_EX_output(100);

    flagRegMux : Mux2 GENERIC MAP(
        4) PORT MAP(
        ALUflagOut, MemoryflagOut, flagRegSelector, EX_MEM_input(193 DOWNTO 190)
    );

    -- forward src1
    EX_MEM_input(31 DOWNTO 0) <= ID_EX_output(31 DOWNTO 0);

    -- forward src2
    EX_MEM_input(63 DOWNTO 32) <= ID_EX_output(63 DOWNTO 32);

    -- forward immediate
    EX_MEM_input(127 DOWNTO 96) <= ID_EX_output(95 DOWNTO 64);

    -- forward WB flags
    EX_MEM_input(131 DOWNTO 128) <= ID_EX_output(99 DOWNTO 96);

    -- forward instruction
    EX_MEM_input(156 DOWNTO 141) <= ID_EX_output(133 DOWNTO 118);

    -- forward mem
    EX_MEM_input(140 DOWNTO 132) <= ID_EX_output(108 DOWNTO 100);

    -- forward pc
    EX_MEM_input(188 DOWNTO 157) <= ID_EX_output(165 DOWNTO 134);

    -- 31:0 src1,      63:32 src2,   95:64 ALU output,
    -- 127:96 immediate(sign extended),
    -- 131:128 WB,     140:132 MEM,    ,    156:141 instruction,
    -- 188:157 pc      189 stop flag  ,  193:190 flag regesiter 
    EX_MEM : pipeLineReg GENERIC MAP(
        194) PORT MAP(
        clock, rst, EX_MEM_input, EX_MEM_output
    );

    ----------------- Memory ----------------------------

    MemoryStage : Memory PORT MAP(
        clock, rst, EX_MEM_output(156 DOWNTO 141),
        EX_MEM_output(140 DOWNTO 132),
        EX_MEM_output(127 DOWNTO 96),
        EX_MEM_output(31 DOWNTO 0),
        EX_MEM_output (193 DOWNTO 190),
        MemoryFlagOut,
        EX_MEM_output(188 DOWNTO 157),
        flagRegSelector,
        inputPort,
        outPort,
        MEM_WB_input(95 DOWNTO 64),
        protectFlag,
        stackPointer,
        rstSignal--data
    );

    -- forward src1
    MEM_WB_input(31 DOWNTO 0) <= EX_MEM_output(31 DOWNTO 0);

    -- forward src2
    MEM_WB_input(63 DOWNTO 32) <= EX_MEM_output(63 DOWNTO 32);

    -- forward alu output
    MEM_WB_input(127 DOWNTO 96) <= EX_MEM_output(95 DOWNTO 64);

    -- forward immediate
    MEM_WB_input(159 DOWNTO 128) <= EX_MEM_output(127 DOWNTO 96);

    -- forward WB
    MEM_WB_input(163 DOWNTO 160) <= EX_MEM_output(131 DOWNTO 128);

    -- forward instruction
    MEM_WB_input(179 DOWNTO 164) <= EX_MEM_output(156 DOWNTO 141);

    -- forward pc
    MEM_WB_input(211 DOWNTO 180) <= EX_MEM_output(188 DOWNTO 157);
    -- 31:0 src1,   63:32 src2,     95:64 mem,      127:96 alu,
    -- 159:128 immediate,    163:160 WB,       179:164 instruction,
    -- 211:180 pc
    MEM_WB : pipeLineReg GENERIC MAP(
        212) PORT MAP(
        clock, rst, MEM_WB_input, MEM_WB_output
    );

    ----------------- Write Back ----------------------------
    WritingBack : WriteBack PORT MAP(
        clock, rst, MEM_WB_output(179 DOWNTO 164),
        MEM_WB_output(163 DOWNTO 160),
        MEM_WB_output(159 DOWNTO 128),
        MEM_WB_output(127 DOWNTO 96),
        MEM_WB_output(95 DOWNTO 64),
        MEM_WB_output(63 DOWNTO 32),
        MEM_WB_output(31 DOWNTO 0),
        writeBack1EnableSig,
        writeBack2EnableSig,
        writeBack1AddressSig,
        writeBack2AddressSig,
        writeBack1DataSig,
        writeBack2DataSig,
        memoryPcSig);
END ARCHITECTURE;