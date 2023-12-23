LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY TFlipFlop IS
    PORT (
        t, rst, preset, clk : IN STD_LOGIC;
        q, qbar : OUT STD_LOGIC
    );
END TFlipFlop;

ARCHITECTURE ArchTFlipFlop OF TFlipFlop IS

    SIGNAL temp : STD_LOGIC;

BEGIN

    PROCESS (clk, rst, preset)
    BEGIN
        -- reset
        IF rst = '1' THEN
            temp <= '0';

            -- preset
        ELSIF preset = '1' THEN
            temp <= '1';

            -- active high
        ELSIF rising_edge(clk) THEN

            -- toggle
            IF t = '0' THEN
                temp <= temp;

                -- store
            ELSE
                temp <= NOT(temp);

            END IF;
        END IF;

    END PROCESS;

    q <= temp;
    qbar <= NOT (temp);
END ARCHITECTURE;