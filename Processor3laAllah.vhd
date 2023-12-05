LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Processor IS
    PORT (
        rst : IN STD_LOGIC;
        inputPort : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        assemblerWR : IN STD_LOGIC;
        assemblerInstruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        assemblerPC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        inttrupt : IN STD_LOGIC;
        outPort : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END Processor;

ARCHITECTURE ArchProcessor OF Processor IS
    COMPONENT Fetch IS
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
    END COMPONENT Fetch;
    COMPONENT Decode IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            -- pcIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
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
            jmpFlag : OUT STD_LOGIC
            -- instructionOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            -- pcOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
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

            --IO
            inputPort : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            outputPort : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

            memoryOut : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)

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
    SIGNAL IF_ID_input : STD_LOGIC_VECTOR(64 DOWNTO 0) := (OTHERS => '0');
    SIGNAL IF_ID_output : STD_LOGIC_VECTOR(64 DOWNTO 0) := (OTHERS => '0');

    SIGNAL ID_EX_input : STD_LOGIC_VECTOR(164 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ID_EX_output : STD_LOGIC_VECTOR(164 DOWNTO 0) := (OTHERS => '0');

    SIGNAL EX_MEM_input : STD_LOGIC_VECTOR(194 DOWNTO 0) := (OTHERS => '0');
    SIGNAL EX_MEM_output : STD_LOGIC_VECTOR(194 DOWNTO 0) := (OTHERS => '0');

    SIGNAL MEM_WB_input : STD_LOGIC_VECTOR(212 DOWNTO 0) := (OTHERS => '0');
    SIGNAL MEM_WB_output : STD_LOGIC_VECTOR(212 DOWNTO 0) := (OTHERS => '0');

    -- WR outputs
    SIGNAL writeBack1EnableSig : STD_LOGIC;
    SIGNAL writeBack2EnableSig : STD_LOGIC;
    SIGNAL writeBack1AddressSig : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL writeBack2AddressSig : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL writeBack1DataSig : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL writeBack2DataSig : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memoryPcSig : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    PROCESS
    BEGIN
        WAIT FOR 15 ns;
        clock <= NOT clock;
    END PROCESS;

    ----------------- Fetching -----------------------------

    Fetching : Fetch PORT MAP(
        clock, rst, '0', '0', '0', '0',
        assemblerWR, IF_ID_input(32), IF_ID_output(31 DOWNTO 16), assemblerInstruction,
        IF_ID_input(31 DOWNTO 16), IF_ID_input(15 DOWNTO 0), (OTHERS => '0'), memoryPcSig,
        (OTHERS => '0'), assemblerPC, IF_ID_input(64 DOWNTO 33)
    );

    -- 15 : 0  immidate ,  31 :16 instruction , 32 freeze(imm) , 64 :33 PC 
    IF_ID : PipeLineReg GENERIC MAP(
        65) PORT MAP(
        clock, rst, IF_ID_input, IF_ID_output
    );

    ----------------- Decoding ----------------------------

    Decoding : Decode PORT MAP(
        clock,
        rst,
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
        ID_EX_input(117)
    );

    -- 31:0 src1,       63:32 src2,     95:64 immediate(sign extended),
    -- 99:96 WB,       108:100 MEM,    116:109 ALU,    117 jmpFlag
    -- 133:118 instruction,      165:134 pc
    ID_EX : pipeLineReg GENERIC MAP(
        165) PORT MAP(
        clock, rst, ID_EX_input, ID_EX_output
    );

    ----------------- Execute ----------------------------

    Executing : Execute PORT MAP(
        clock,
        ID_EX_output(116),
        ID_EX_output(118),
        ID_EX_output(115),
        ID_EX_output(114),
        ID_EX_output(113),
        ID_EX_output(112 DOWNTO 109),
        ID_EX_output(31 DOWNTO 0),
        ID_EX_output(63 DOWNTO 32),
        ID_EX_output(95 DOWNTO 64),

        EX_MEM_input(193 DOWNTO 190),
        EX_MEM_input(95 DOWNTO 64)
    );

    -- 31:0 src1,       63:32 src2,   95:64 ALU output,
    --  127:96 immediate(sign extended),
    -- 131:128 WB,       140:132 MEM,    ,    156:141 instruction,
    -- 188:157 pc      189 stop flag  ,  193:190 flag regesiter 
    EX_MEM : pipeLineReg GENERIC MAP(
        195) PORT MAP(
        clock, rst, EX_MEM_input, EX_MEM_output
    );

    ----------------- Memory ----------------------------

    MemoryStage : Memory PORT MAP(
        clock, rst, EX_MEM_output(156 DOWNTO 141),
        EX_MEM_output(140 DOWNTO 132),
        EX_MEM_output(127 DOWNTO 96),
        EX_MEM_output(31 DOWNTO 0),
        EX_MEM_output (193 DOWNTO 190),
        EX_MEM_input (193 DOWNTO 190),
        EX_MEM_output(188 DOWNTO 157),
        inputPort,
        outPort,
        MEM_WB_input(95 DOWNTO 64)
    );

    -- 31:0 src1,   63:32 src2,     95:64 mem,      127:96 alu,
    -- 159:128 immediate,    163:160 WB,       179:164 instruction
    MEM_WB : pipeLineReg GENERIC MAP(
        213) PORT MAP(
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