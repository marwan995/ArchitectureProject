LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY HazardDetectionUnit IS
    PORT (
        --instruction
        instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
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
BEGIN
    -------------------------------initialize the operand ----------------------------
    zeroOperand <= (instruction(15)) NOR (instruction(14));
    oneOperand <= NOT((instruction(15))) AND instruction(14);
    twoOperand <= instruction(15) AND NOT(instruction(14));
    threeOperand <= (instruction(15)) AND instruction(14);
    ldm <= ((instruction(5) NOR instruction(4)) AND instruction(3));
    -------------------------------Alu ----------------------------
    ForwordEnable <='1'
        WHEN (reg = memoryReg1 OR reg = memoryReg2 OR reg = aluReg1 OR reg = aluReg2) ELSE
        '0';
    ForwordFrom <= '1'
        WHEN (reg = memoryReg1 OR reg = memoryReg2) ELSE
        '0';
END ARCHITECTURE;