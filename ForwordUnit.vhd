LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ForwardUnit IS
    PORT (
        regSrc2: IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        aluRegAlu : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluRegImmedate : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluRegSrc1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluRegSrc2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        MemoryRegALu : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        MemoryRegImmedate : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        MemoryRegSrc1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        MemoryRegSrc2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        MemoryRegMemory:IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        forwardAluSelector : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        forwardMemoryEnable : IN STD_LOGIC;
        forwardEnable : IN STD_LOGIC;
        forwardFrom : IN STD_LOGIC;

        forwardOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ForwardUnit;

ARCHITECTURE ArachForwardUnit OF ForwardUnit IS
    COMPONENT Mux4 IS
        GENERIC (n : INTEGER := 1);
        PORT (
            a : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            c : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            d : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            selector : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            output : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT Mux4;
    COMPONENT Mux2 IS
        GENERIC (n : INTEGER := 16);
        PORT (
            a : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            selector : IN STD_LOGIC;
            output : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT Mux2;
    SIGNAL memoryValue, aluValue,aluOrMemoryValue,memoryPiriority : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    aluValueMux : Mux4 GENERIC MAP(
        32)PORT MAP(
        aluRegALu, aluRegImmedate, aluRegSrc1, aluRegSrc2,forwardAluSelector , aluValue
    );

    MemoryValueMux : Mux4 GENERIC MAP(
        32)PORT MAP(
        MemoryRegALu, MemoryRegImmedate, MemoryRegSrc1, MemoryRegSrc2,forwardAluSelector ,memoryValue
    );
    MemoryValueOrAluValueMux : Mux2 GENERIC MAP(
        32)PORT MAP(
            aluValue, memoryValue,forwardFrom,aluOrMemoryValue
    );
    MemoryPriorityMux : Mux2 GENERIC MAP(
        32)PORT MAP(
            aluOrMemoryValue, memoryRegMemory,forwardMemoryEnable,memoryPiriority
    );
    
    ForwardOutMux : Mux2 GENERIC MAP(
        32)PORT MAP(
            regSrc2 , memoryPiriority,forwardEnable,forwardOut
    );



END ARCHITECTURE;