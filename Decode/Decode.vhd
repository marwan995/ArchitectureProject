LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Decode IS
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
        register7 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        reg1NumOut : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        reg2NumOut : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)

        -- reg1Test: out std_logic_vector(2 downto 0);
        -- reg2Test: out std_logic_vector(2 downto 0)
        -- instructionOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        -- pcOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    );
END Decode;

ARCHITECTURE ArchDecode OF Decode IS
    COMPONENT SignExtend IS
        PORT (
            inVector : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            outVector : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT SignExtend;
    COMPONENT RegFile IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;

            regNum1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            regNum2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

            writeBack1Enable : IN STD_LOGIC;
            writeBack2Enable : IN STD_LOGIC;

            writeBack1Num : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            writeBack2Num : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

            writeBack1Data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            writeBack2Data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            dataBus1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataBus2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

            register0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register5 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register6 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            register7 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT ControlUnit IS
        PORT (

            --instruction
            instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            freeze : IN STD_LOGIC;

            -- --alu 
            aluEnable : OUT STD_LOGIC;
            src1Selector : OUT STD_LOGIC;
            src2Selector : OUT STD_LOGIC;
            src3Selector : OUT STD_LOGIC;
            aluOperationSelector : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

            -- memory
            memoryEnable : OUT STD_LOGIC;
            memoryOrIO : OUT STD_LOGIC;
            readOrWrite : OUT STD_LOGIC;
            addressSelector : OUT STD_LOGIC;
            memoryValueFlag : OUT STD_LOGIC;
            spEnable : OUT STD_LOGIC;
            spIncOrDec : OUT STD_LOGIC;
            protectMemory : OUT STD_LOGIC;
            jumpStopFlag : OUT STD_LOGIC;

            --write back
            writeBackEnable : OUT STD_LOGIC;
            reg2Write : OUT STD_LOGIC;
            writeBackSelector : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);

            --pc
            jmpFlag : OUT STD_LOGIC

        );
    END COMPONENT ControlUnit;

    SIGNAL regNum1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL regNum2 : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN
    ExtendTheImmedateValue : SignExtend PORT MAP(
        immedateValue, immedateValueExtended
    );

    reg1NumOut <=  regNum1;
    reg2NumOut <=  regNum2;

    regNum1 <= instruction(10 DOWNTO 8) WHEN (instruction(15) = '1' AND instruction(14) = '0' AND instruction(2) = '0' AND instruction(2) = '0')
        OR
        (instruction(15) = '1' AND instruction(14) = '1')
        ELSE
        instruction(13 DOWNTO 11)
        ;

    regNum2 <= instruction(7 DOWNTO 5) WHEN
        (instruction(15) = '1' AND instruction(14) = '1')
        ELSE
        instruction(13 DOWNTO 11) WHEN (instruction(15) = '1' AND instruction(14) = '0'AND (instruction(2 DOWNTO 1) = "00")) ELSE
        instruction(10 DOWNTO 8)
        ;

    UpdateTheRegisters : RegFile PORT MAP(-- if 3 oprand  takes 2 , 3
        clk,
        rst,
        regNum1,
        regNum2,
        writeBack1Enable,
        writeBack2Enable,
        writeBack1Address,
        writeBack2Address,
        writeBack1Data,
        writeBack2Data,
        reg1Value,
        reg2Value,
        register0,
        register1,
        register2,
        register3,
        register4,
        register5,
        register6,
        register7
    );

    CreateControlSignals : ControlUnit PORT MAP(
        instruction,
        freeze,
        alu(7),
        alu(6),
        alu(5),
        alu(4),
        alu(3 DOWNTO 0),
        memory(8),
        memory(7),
        memory(6),
        memory(5),
        memory(4),
        memory(3),
        memory(2),
        memory(1),
        memory(0),
        writeBack(3),
        writeBack(2),
        writeBack(1 DOWNTO 0),
        jmpFlag
    );
END ARCHITECTURE;