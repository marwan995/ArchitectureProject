LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Decode IS
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

            regNum1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            regNum2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

            writeBack1Enable : IN STD_LOGIC;
            writeBack2Enable : IN STD_LOGIC;

            writeBack1Num : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            writeBack2Num : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

            writeBack1Data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            writeBack2Data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            dataBus1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataBus2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT ControlUnit IS
        PORT (

            --instruction
            instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

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

    regNum1 <= instruction(10 DOWNTO 8) WHEN (instruction(15) AND NOT(instruction(14))) OR ((instruction(15)) AND instruction(14))
        ELSE
        instruction(13 DOWNTO 11)
        ;

    regNum2 <= instruction(7 DOWNTO 5) WHEN (instruction(15) AND NOT(instruction(14))) OR ((instruction(15)) AND instruction(14))
        ELSE
        instruction(10 DOWNTO 8)
        ;

    UpdateTheRegisters : RegFile PORT MAP(-- if 3 oprand  takes 2 , 3
        clk, regNum1, regNum2,
        writeBack1Enable, writeBack2Enable,
        writeBack1Address, writeBack2Address, writeBack1Data, writeBack2Data, reg1Value, reg2Value
    );

    CreateControlSignals : ControlUnit PORT MAP(
        instruction,
        alu(7), alu(6), alu(5), alu(4), alu(3 DOWNTO 0),
        memory(8), memory(7), memory(6), memory(5), memory(4), memory(3), memory(2), memory(1), memory(0),
        writeBack(3), writeBack(2), writeBack(1 DOWNTO 0)
        , jmpFlag
    );
END ARCHITECTURE;