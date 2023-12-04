LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RegFile IS
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
END RegFile;

ARCHITECTURE ArchRegFile OF RegFile IS

    COMPONENT REG IS
        GENERIC (n : INTEGER := 32);
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            inData : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            outData : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT REG;

    COMPONENT TriStateBuffer IS
        GENERIC (
            WIDTH : INTEGER := 32
        );
        PORT (
            enable : IN STD_LOGIC;
            input : IN STD_LOGIC_VECTOR(WIDTH - 1 DOWNTO 0);
            output : OUT STD_LOGIC_VECTOR(WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT TriStateBuffer;

    COMPONENT RegDecode IS
        PORT (
            regNum : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            bufferNum : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT RegDecode;

    COMPONENT Mux2 IS
        GENERIC (n : INTEGER := 1);
        PORT (
            a : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            selector : IN STD_LOGIC;
            output : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT Mux2;

    SIGNAL buffer1EnableList : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL buffer2EnableList : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL writeBackReg1EnableList : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL writeBackReg2EnableList : STD_LOGIC_VECTOR(7 DOWNTO 0);

    SIGNAL reg0Output : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg1Output : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg2Output : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg3Output : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg4Output : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg5Output : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg6Output : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg7Output : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL reg0MuxOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg1MuxOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg2MuxOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg3MuxOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg4MuxOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg5MuxOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg6MuxOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg7MuxOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL tristate0InputBus1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL tristate1InputBus1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL tristate2InputBus1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL tristate3InputBus1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL tristate4InputBus1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL tristate5InputBus1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL tristate6InputBus1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL tristate7InputBus1 : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL tristate0InputBus2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL tristate1InputBus2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL tristate2InputBus2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL tristate3InputBus2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL tristate4InputBus2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL tristate5InputBus2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL tristate6InputBus2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL tristate7InputBus2 : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL reg0Clk : STD_LOGIC;
    SIGNAL reg1Clk : STD_LOGIC;
    SIGNAL reg2Clk : STD_LOGIC;
    SIGNAL reg3Clk : STD_LOGIC;
    SIGNAL reg4Clk : STD_LOGIC;
    SIGNAL reg5Clk : STD_LOGIC;
    SIGNAL reg6Clk : STD_LOGIC;
    SIGNAL reg7Clk : STD_LOGIC;

BEGIN
    -- 8 tristate buffer each one 1 bit from the input decoders

    -- decoding for regs
    operand1Reg : RegDecode PORT MAP(regNum1, buffer1EnableList);
    operand2Reg : RegDecode PORT MAP(regNum2, buffer2EnableList);

    -- decoding for writeback
    writeBack1Reg : RegDecode PORT MAP(writeBack1Num, writeBackReg1EnableList);
    writeBack2Reg : RegDecode PORT MAP(writeBack2Num, writeBackReg2EnableList);

    -- tristates for bus 1
    tristate0bus1 : TriStateBuffer GENERIC MAP(32) PORT MAP(buffer1EnableList(0), tristate0InputBus1, dataBus1);
    tristate1bus1 : TriStateBuffer GENERIC MAP(32) PORT MAP(buffer1EnableList(1), tristate1InputBus1, dataBus1);
    tristate2bus1 : TriStateBuffer GENERIC MAP(32) PORT MAP(buffer1EnableList(2), tristate2InputBus1, dataBus1);
    tristate3bus1 : TriStateBuffer GENERIC MAP(32) PORT MAP(buffer1EnableList(3), tristate3InputBus1, dataBus1);
    tristate4bus1 : TriStateBuffer GENERIC MAP(32) PORT MAP(buffer1EnableList(4), tristate4InputBus1, dataBus1);
    tristate5bus1 : TriStateBuffer GENERIC MAP(32) PORT MAP(buffer1EnableList(5), tristate5InputBus1, dataBus1);
    tristate6bus1 : TriStateBuffer GENERIC MAP(32) PORT MAP(buffer1EnableList(6), tristate6InputBus1, dataBus1);
    tristate7bus1 : TriStateBuffer GENERIC MAP(32) PORT MAP(buffer1EnableList(7), tristate7InputBus1, dataBus1);

    -- tristates for bus 2
    tristate0bus2 : TriStateBuffer GENERIC MAP(32) PORT MAP(buffer2EnableList(0), tristate0InputBus2, dataBus2);
    tristate1bus2 : TriStateBuffer GENERIC MAP(32) PORT MAP(buffer2EnableList(1), tristate1InputBus2, dataBus2);
    tristate2bus2 : TriStateBuffer GENERIC MAP(32) PORT MAP(buffer2EnableList(2), tristate2InputBus2, dataBus2);
    tristate3bus2 : TriStateBuffer GENERIC MAP(32) PORT MAP(buffer2EnableList(3), tristate3InputBus2, dataBus2);
    tristate4bus2 : TriStateBuffer GENERIC MAP(32) PORT MAP(buffer2EnableList(4), tristate4InputBus2, dataBus2);
    tristate5bus2 : TriStateBuffer GENERIC MAP(32) PORT MAP(buffer2EnableList(5), tristate5InputBus2, dataBus2);
    tristate6bus2 : TriStateBuffer GENERIC MAP(32) PORT MAP(buffer2EnableList(6), tristate6InputBus2, dataBus2);
    tristate7bus2 : TriStateBuffer GENERIC MAP(32) PORT MAP(buffer2EnableList(7), tristate7InputBus2, dataBus2);

    -- reg input (muxes)
    reg0DataIn : Mux2 GENERIC MAP(32) PORT MAP(writeBack1Data, writeBack2Data, writeBack2Enable, reg0MuxOutput);
    reg1DataIn : Mux2 GENERIC MAP(32) PORT MAP(writeBack1Data, writeBack2Data, writeBack2Enable, reg1MuxOutput);
    reg2DataIn : Mux2 GENERIC MAP(32) PORT MAP(writeBack1Data, writeBack2Data, writeBack2Enable, reg2MuxOutput);
    reg3DataIn : Mux2 GENERIC MAP(32) PORT MAP(writeBack1Data, writeBack2Data, writeBack2Enable, reg3MuxOutput);
    reg4DataIn : Mux2 GENERIC MAP(32) PORT MAP(writeBack1Data, writeBack2Data, writeBack2Enable, reg4MuxOutput);
    reg5DataIn : Mux2 GENERIC MAP(32) PORT MAP(writeBack1Data, writeBack2Data, writeBack2Enable, reg5MuxOutput);
    reg6DataIn : Mux2 GENERIC MAP(32) PORT MAP(writeBack1Data, writeBack2Data, writeBack2Enable, reg6MuxOutput);
    reg7DataIn : Mux2 GENERIC MAP(32) PORT MAP(writeBack1Data, writeBack2Data, writeBack2Enable, reg7MuxOutput);

    -- reg enables
    reg0Clk <= clk AND (writeBackReg1EnableList(0) OR writeBackReg2EnableList(0));
    reg1Clk <= clk AND (writeBackReg1EnableList(1) OR writeBackReg2EnableList(1));
    reg2Clk <= clk AND (writeBackReg1EnableList(2) OR writeBackReg2EnableList(2));
    reg3Clk <= clk AND (writeBackReg1EnableList(3) OR writeBackReg2EnableList(3));
    reg4Clk <= clk AND (writeBackReg1EnableList(4) OR writeBackReg2EnableList(4));
    reg5Clk <= clk AND (writeBackReg1EnableList(5) OR writeBackReg2EnableList(5));
    reg6Clk <= clk AND (writeBackReg1EnableList(6) OR writeBackReg2EnableList(6));
    reg7Clk <= clk AND (writeBackReg1EnableList(7) OR writeBackReg2EnableList(7));

    -- regs
    reg0 : REG GENERIC MAP(32) PORT MAP(reg0Clk, '0', reg0MuxOutput, reg0Output);
    reg1 : REG GENERIC MAP(32) PORT MAP(reg1Clk, '0', reg1MuxOutput, reg1Output);
    reg2 : REG GENERIC MAP(32) PORT MAP(reg2Clk, '0', reg2MuxOutput, reg2Output);
    reg3 : REG GENERIC MAP(32) PORT MAP(reg3Clk, '0', reg3MuxOutput, reg3Output);
    reg4 : REG GENERIC MAP(32) PORT MAP(reg4Clk, '0', reg4MuxOutput, reg4Output);
    reg5 : REG GENERIC MAP(32) PORT MAP(reg5Clk, '0', reg5MuxOutput, reg5Output);
    reg6 : REG GENERIC MAP(32) PORT MAP(reg6Clk, '0', reg6MuxOutput, reg6Output);
    reg7 : REG GENERIC MAP(32) PORT MAP(reg7Clk, '0', reg7MuxOutput, reg7Output);

    -- assign reg output to tristate input
    tristate0InputBus1 <= reg0Output;
    tristate1InputBus1 <= reg1Output;
    tristate2InputBus1 <= reg2Output;
    tristate3InputBus1 <= reg3Output;
    tristate4InputBus1 <= reg4Output;
    tristate5InputBus1 <= reg5Output;
    tristate6InputBus1 <= reg6Output;
    tristate7InputBus1 <= reg7Output;

    tristate0InputBus2 <= reg0Output;
    tristate1InputBus2 <= reg1Output;
    tristate2InputBus2 <= reg2Output;
    tristate3InputBus2 <= reg3Output;
    tristate4InputBus2 <= reg4Output;
    tristate5InputBus2 <= reg5Output;
    tristate6InputBus2 <= reg6Output;
    tristate7InputBus2 <= reg7Output;

END ARCHITECTURE;