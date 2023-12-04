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
    END COMPONENT REG;
    SIGNAL pcSig : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL pcOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memOut, memCom : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    LabelA : instructionMemory PORT MAP(
        clk, wr, pcOut(11 DOWNTO 0), memCom,
        memOut
    );
    LabelB : REG GENERIC MAP(
        32) PORT MAP(
        clk, rst, pcSig, pcOut
    );

    pcSig(11 DOWNTO 0) <= addr;
    memCom <= data;
        output <= memOut;
END ARCHITECTURE;
