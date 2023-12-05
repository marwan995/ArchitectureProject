LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY protectedMemory IS
    PORT (
        clk : IN STD_LOGIC;
        w_r : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        protectedin : IN STD_LOGIC;
        protectedout : OUT STD_LOGIC);
END ENTITY protectedMemory;

ARCHITECTURE Arch_protectedMemory OF protectedMemory IS TYPE protectedMemory_type
    IS ARRAY(0 TO 4096) OF STD_LOGIC;
    SIGNAL protectedMemory : protectedMemory_type:= (
        others =>'0'
    );
BEGIN
    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            IF enable = '1' THEN
                IF w_r = '1' THEN
                    protectedMemory(to_integer(unsigned((address)))) <= protectedin;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    protectedout <=  'Z' WHEN enable = '0' ELSE
        protectedMemory(to_integer(unsigned((address))));
END Arch_protectedMemory;