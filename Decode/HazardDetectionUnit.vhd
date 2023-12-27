LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY HazardDetectionUnit IS
    PORT (
        --instruction
        instructionAlu : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        instructionMemo : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        --Regs 
        reg : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        aluReg1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        aluReg2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        memoryReg1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        memoryReg2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        --Forword
        ForwordEnable : OUT STD_LOGIC;
        ForwordFrom : OUT STD_LOGIC;
        --alu
        ForwordAluSelector : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);

        --memory
        ForwordMemoryEnable : OUT STD_LOGIC
    );
END HazardDetectionUnit;

ARCHITECTURE ArchHazardDetectionUnit OF HazardDetectionUnit IS
    SIGNAL zeroOperand, oneOperand, twoOperand, threeOperand : STD_LOGIC;
    SIGNAL ldm : STD_LOGIC;
    SIGNAL instruction : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL swap : STD_LOGIC;
BEGIN
    instruction <= instructionAlu WHEN (reg = aluReg1 OR reg = aluReg2) ELSE
        instructionMemo;
    -------------------------------initialize the operand ----------------------------
    zeroOperand <= (instruction(15)) NOR (instruction(14));
    oneOperand <= NOT((instruction(15))) AND instruction(14);
    twoOperand <= instruction(15) AND NOT(instruction(14));
    threeOperand <= (instruction(15)) AND instruction(14);
    ldm <= ((instruction(5) NOR instruction(4)) AND instruction(3));
    swap <= (twoOperand) AND ((instruction(1)) NOR (instruction(2)));
    -------------------------------Alu ----------------------------
    ForwordEnable <= '1'
        WHEN (reg = memoryReg1 OR reg = memoryReg2 OR reg = aluReg1 OR reg = aluReg2) ELSE
        '0';
    ForwordFrom <= '0'
        WHEN (reg = aluReg1 OR reg = aluReg2) ELSE
        '1';
    ForwordAluSelector <= "11" WHEN swap = '1' AND (reg = aluReg1 OR reg = memoryReg1) ELSE
        "10" WHEN swap = '1' AND (reg = aluReg2 OR reg = memoryReg2) ELSE
        "01" WHEN ldm = '1' ELSE
        "00";
    ForwordMemoryEnable <= '1' WHEN oneOperand = '1' AND (instruction(6 DOWNTO 3) = "1111" OR instruction(6 DOWNTO 3) = "0100") ELSE
        '0';
END ARCHITECTURE;