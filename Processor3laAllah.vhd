LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Processor IS
    PORT (
        rst : IN STD_LOGIC;
        inputPort : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
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
            ALUOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            ALUCOut : OUT STD_LOGIC
        );
    END COMPONENT Execute;
    COMPONENT Memory IS
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

            --IO
            inputPort : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            outputPort : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

            memoryOut : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)

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
    SIGNAL clock : STD_LOGIC := '1';
    
BEGIN
PROCESS
    BEGIN
        WAIT FOR 15 ns;
        clock <= NOT clock;
    END PROCESS;


    -- Fetching : Fetch PORT MAP(
    --     clock,rst,'0','0','0','0',

    -- );
    IF_ID : Reg port map(
        clock,
    );

END ARCHITECTURE;
----
---