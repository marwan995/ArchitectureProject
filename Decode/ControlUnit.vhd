LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ControlUnit IS
    PORT (

        --instruction
        instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        freeze : IN STD_LOGIC;

        -- --alu 
        aluEnable : OUT STD_LOGIC; --7
        src1Selector : OUT STD_LOGIC; --6
        src2Selector : OUT STD_LOGIC; --5
        src3Selector : OUT STD_LOGIC; --4
        aluOperationSelector : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- 3 to 0

        -- memory
        memoryEnable : OUT STD_LOGIC;--8
        memoryOrIO : OUT STD_LOGIC;--7
        readOrWrite : OUT STD_LOGIC;--6
        addressSelector : OUT STD_LOGIC;--5
        memoryValueFlag : OUT STD_LOGIC;--4
        spEnable : OUT STD_LOGIC;--3
        spIncOrDec : OUT STD_LOGIC;--2
        protectMemory : OUT STD_LOGIC;--1
        jumpStopFlag : OUT STD_LOGIC;--0

        --write back
        writeBackEnable : OUT STD_LOGIC;--3
        reg2Write : OUT STD_LOGIC;--2
        writeBackSelector : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);--1 to 0

        --pc
        jmpFlag : OUT STD_LOGIC

    );
END ControlUnit;

ARCHITECTURE ArchControlUnit OF ControlUnit IS

    SIGNAL zeroOperand, oneOperand, twoOperand, threeOperand : STD_LOGIC;
    SIGNAL pcTemp, memoryValueTemp : STD_LOGIC;
    SIGNAL isJump : STD_LOGIC;

BEGIN
    -------------------------------initialize the operand ----------------------------
    zeroOperand <= (instruction(15)) NOR (instruction(14));
    oneOperand <= NOT((instruction(15))) AND instruction(14);
    twoOperand <= instruction(15) AND NOT(instruction(14));
    threeOperand <= (instruction(15)) AND instruction(14);
    isJump <= (oneOperand AND (instruction(1) OR instruction(2)));

    -------------------------------Write Back ----------------------------
    writeBackEnable <= NOT(not(freeze) AND instruction(0)) AND
        ((oneOperand AND(instruction(1)NOR instruction(2)) AND (NOT(instruction(6)) OR (NOT(instruction(5)) AND instruction(0)) OR (instruction(3)AND instruction(4)))) OR
        (twoOperand AND (instruction(2) NAND instruction(1)))OR
        (threeOperand));

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
    -------------------------------Memory ----------------------------
    readOrWrite <= (isJump OR (oneOperand AND (instruction(1) NOR instruction(2)) AND (instruction(6) AND (instruction(3) NAND instruction(4)))));
    memoryEnable <= NOT(not(freeze) AND instruction(0)) AND
        ((zeroOperand AND instruction(6))OR
        (oneOperand AND (instruction(6) AND instruction(5)))OR
        (oneOperand AND (instruction(6) XOR instruction(5)) AND (instruction(3) NOR instruction(4)))OR
        (oneOperand AND (instruction(1) AND instruction(2))))
        ;
    memoryOrIO <=
        (oneOperand AND (instruction(3) NOR instruction(4)) AND (instruction(5) XOR instruction(6)));
    addressSelector <=
        (oneOperand AND (instruction(6)AND instruction(5) AND NOT (instruction(4))));

    memoryValueTemp <= (NOT instruction(15) AND (instruction(1) AND instruction(2)));
    memoryValueFlag <= memoryValueTemp;
    pcTemp <= (zeroOperand AND instruction(4));
    jmpFlag <= (memoryValueTemp OR pcTemp);
    spEnable <= pcTemp OR memoryValueTemp OR (oneOperand AND(instruction(4)AND instruction(5) AND instruction(6))AND NOT(instruction(0)));
    spIncOrDec <= pcTemp OR (oneOperand AND(NOT (instruction(0)) AND instruction(3) AND instruction(4) AND instruction(5) AND instruction(6)));
    protectMemory <= (oneOperand AND (instruction(6)AND instruction(5) AND NOT (instruction(4))));
    jumpStopFlag <= ((zeroOperand AND instruction(2)) OR (memoryValueTemp));
    -------------------------------Alu ----------------------------
    aluEnable <= NOT(not(freeze) AND instruction(0)) AND ((oneOperand AND NOT(instruction(6)) AND (instruction(1) NOR instruction(2))) OR
        (threeOperand)OR
        (twoOperand AND instruction(1)));
    src1Selector <= (threeOperand) OR (twoOperand AND instruction(0));
    src2Selector <= (twoOperand OR oneOperand) AND(instruction(0) AND NOT(instruction(6)));
    src3Selector <= threeOperand;
    aluOperationSelector(3) <= (threeOperand)OR
    (twoOperand AND instruction(1));

    aluOperationSelector(2) <= ((threeOperand AND instruction(2)) OR
    (oneOperand AND ((instruction(5) AND (instruction(4)OR instruction(3))) OR (NOT instruction(5) AND (instruction(4)AND instruction(3)))))
    );

    aluOperationSelector(1) <= ((threeOperand AND instruction(4)) OR
    (oneOperand AND (NOT instruction(6) AND(instruction(5)AND instruction(4)))
    )OR
    (oneOperand AND (NOT instruction(6) AND NOT instruction(5) AND (instruction(4) XOR instruction(3))))
    );

    aluOperationSelector(0) <= ((threeOperand AND (instruction(1) NAND instruction(3))) OR
    (twoOperand AND instruction(0))OR
    (oneOperand AND instruction(0) AND instruction(3))OR
    (oneOperand AND (NOT instruction(0) AND NOT instruction(6) AND NOT instruction(3)))

    );
    -------------------------------PC ----------------------------
    jmpFlag <= oneOperand AND (instruction(1) XOR instruction(2));

END ARCHITECTURE;