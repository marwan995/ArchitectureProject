LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Container IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        wr : STD_LOGIC;
        data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        addr : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END Container;

ARCHITECTURE ArchContainer OF Container IS
    COMPONENT instructionMemory IS
        PORT (
            clk : IN STD_LOGIC;
            w_r : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
    END COMPONENT instructionMemory;

    COMPONENT REG IS
        GENERIC (n : INTEGER := 32);
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            inData : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            outData : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL pcSig : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL pcOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL w_r : STD_LOGIC;
    SIGNAL memOut, memCom : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    LabelA : instructionMemory PORT MAP(
        clk, w_r, pcOut(11 DOWNTO 0), memCom,
        memOut
    );
    LabelB : REG GENERIC MAP(
        32) PORT MAP(
        clk, rst, pcSig, pcOut
    );

    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            pcSig <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF wr = '1' THEN
                w_r <= '1';
                pcSig(11 DOWNTO 0) <= addr;
                memCom <= data;
                output <= (OTHERS => '0');

            ELSE
                pcSig(11 DOWNTO 0) <= addr;
                w_r <= '0';
                output <= memOut;
            END IF;
        END IF;

    END PROCESS;
END ARCHITECTURE;