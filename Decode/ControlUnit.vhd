LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ControlUnit IS
    PORT (

        --instruction
        instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        -- --alu 
        -- aluEnable : OUT STD_LOGIC;
        -- src1Selector : OUT STD_LOGIC;
        -- src2Selector : OUT STD_LOGIC;
        -- src3Selector : OUT STD_LOGIC;
        -- aluOperationSelector : OUT STD_LOGIC;

        -- memory
        memoryEnable : OUT STD_LOGIC;
        -- memoryOrIO : OUT STD_LOGIC;
        -- readOrWrite : OUT STD_LOGIC;
        -- addressSelector : OUT STD_LOGIC;
        -- memoryValueFlag : OUT STD_LOGIC;
        -- pcUpdate : OUT STD_LOGIC;
        -- spIncOrDec : OUT STD_LOGIC;
        -- protectMemory : OUT STD_LOGIC;
        -- jumpStopFlag : OUT STD_LOGIC;

        --write back
        writeBackEnable : OUT STD_LOGIC;
        reg2Write : OUT STD_LOGIC;
        writeBackSelector : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)

        --pc
        -- jmpFlag : OUT STD_LOGIC;
        -- pcMemoryFlag : OUT STD_LOGIC

    );
END ControlUnit;

ARCHITECTURE ArchControlUnit OF ControlUnit IS

    SIGNAL zeroOperand, oneOperand, twoOperand, threeOperand : STD_LOGIC;

BEGIN
    -- initialize the operand
    zeroOperand <= (instruction(15)) nor (instruction(14));
    oneOperand <= NOT((instruction(15))) AND instruction(14);
    twoOperand <= instruction(15) AND NOT(instruction(14));
    threeOperand <= (instruction(15)) AND instruction(14);

    -------------------------------Write Back ----------------------------
    writeBackEnable <=
        (oneOperand AND (instruction(1) NOR instruction(2))) OR
        (twoOperand AND (instruction(2) nand instruction(1)))OR
        (threeOperand);

    reg2Write <= (twoOperand) AND ((instruction(1)) NOR (instruction(2)));
    writeBackSelector(0) <=
    ((threeOperand) OR
    (twoOperand AND (NOT instruction(2) AND instruction(1))) OR
    (oneOperand AND (instruction(6)NOR instruction(5))) OR
    (oneOperand AND ((NOT instruction(6) AND instruction(5)) AND (instruction(4) OR instruction(3)))) OR
    (oneOperand AND ((instruction(6) AND NOT instruction(5) AND NOT instruction(4) AND instruction(3))))
    );

    writeBackSelector(1) <= (oneOperand AND (NOT instruction(6) AND instruction(5) AND NOT instruction(4) AND NOT instruction(3))) OR
    (oneOperand AND (instruction(6) AND NOT instruction(5) AND NOT instruction(4) AND instruction(3))) OR
    (oneOperand AND (instruction(6)AND instruction(5) AND instruction(4) AND instruction(3)) AND instruction(0));
    -------------------------------memory ----------------------------
    memoryEnable <=
        (zeroOperand AND instruction(6))OR
        (oneOperand AND (instruction(6) AND instruction(5)))OR
        (oneOperand AND (instruction(6) XOR instruction(5)) AND (instruction(3) NOR instruction(4)))OR
        (oneOperand AND (instruction(1) AND instruction(2)))

        ;

END ARCHITECTURE;
