LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RegFile IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;

        regNum1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        regNum2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        writeBack1Enable : IN STD_LOGIC;
        writeBack2Enable : IN STD_LOGIC;

        writeBack1Num : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        writeBack2Num : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        writeBack1Data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        writeBack2Data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        dataBus1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataBus2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        register0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register5 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register6 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        register7 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END RegFile;

ARCHITECTURE ArchRegFile OF RegFile IS

    COMPONENT RegFileREG IS
        GENERIC (n : INTEGER := 32);
        PORT (
            clk : IN STD_LOGIC;
            en : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            inData : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            outData : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT RegFileREG;

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

    SIGNAL out0Mux : STD_LOGIC;
    SIGNAL out1Mux : STD_LOGIC;
    SIGNAL out2Mux : STD_LOGIC;
    SIGNAL out3Mux : STD_LOGIC;
    SIGNAL out4Mux : STD_LOGIC;
    SIGNAL out5Mux : STD_LOGIC;
    SIGNAL out6Mux : STD_LOGIC;
    SIGNAL out7Mux : STD_LOGIC;

    SIGNAL reg0WriteEnable : STD_LOGIC;
    SIGNAL reg1WriteEnable : STD_LOGIC;
    SIGNAL reg2WriteEnable : STD_LOGIC;
    SIGNAL reg3WriteEnable : STD_LOGIC;
    SIGNAL reg4WriteEnable : STD_LOGIC;
    SIGNAL reg5WriteEnable : STD_LOGIC;
    SIGNAL reg6WriteEnable : STD_LOGIC;
    SIGNAL reg7WriteEnable : STD_LOGIC;

    SIGNAL tristate0EnableBus1 : STD_LOGIC;
    SIGNAL tristate1EnableBus1 : STD_LOGIC;
    SIGNAL tristate2EnableBus1 : STD_LOGIC;
    SIGNAL tristate3EnableBus1 : STD_LOGIC;
    SIGNAL tristate4EnableBus1 : STD_LOGIC;
    SIGNAL tristate5EnableBus1 : STD_LOGIC;
    SIGNAL tristate6EnableBus1 : STD_LOGIC;
    SIGNAL tristate7EnableBus1 : STD_LOGIC;

    SIGNAL tristate0EnableBus2 : STD_LOGIC;
    SIGNAL tristate1EnableBus2 : STD_LOGIC;
    SIGNAL tristate2EnableBus2 : STD_LOGIC;
    SIGNAL tristate3EnableBus2 : STD_LOGIC;
    SIGNAL tristate4EnableBus2 : STD_LOGIC;
    SIGNAL tristate5EnableBus2 : STD_LOGIC;
    SIGNAL tristate6EnableBus2 : STD_LOGIC;
    SIGNAL tristate7EnableBus2 : STD_LOGIC;

BEGIN
    -- 8 tristate buffer each one 1 bit from the input decoders

    -- decoding for regs
    operand1Reg : RegDecode PORT MAP(regNum1, buffer1EnableList);
    operand2Reg : RegDecode PORT MAP(regNum2, buffer2EnableList);

    -- decoding for writeback
    writeBack1Reg : RegDecode PORT MAP(writeBack1Num, writeBackReg1EnableList);
    writeBack2Reg : RegDecode PORT MAP(writeBack2Num, writeBackReg2EnableList);

    -- tristate0EnableBus1 <= buffer1EnableList(0) AND NOT(writeBackReg1EnableList(0) OR writeBackReg2EnableList(0));
    tristate0EnableBus1 <= buffer1EnableList(0) AND NOT(clk);
    tristate1EnableBus1 <= buffer1EnableList(1) AND NOT(clk);
    tristate2EnableBus1 <= buffer1EnableList(2) AND NOT(clk);
    tristate3EnableBus1 <= buffer1EnableList(3) AND NOT(clk);
    tristate4EnableBus1 <= buffer1EnableList(4) AND NOT(clk);
    tristate5EnableBus1 <= buffer1EnableList(5) AND NOT(clk);
    tristate6EnableBus1 <= buffer1EnableList(6) AND NOT(clk);
    tristate7EnableBus1 <= buffer1EnableList(7) AND NOT(clk);

    tristate0EnableBus2 <= buffer2EnableList(0) AND NOT(clk);
    tristate1EnableBus2 <= buffer2EnableList(1) AND NOT(clk);
    tristate2EnableBus2 <= buffer2EnableList(2) AND NOT(clk);
    tristate3EnableBus2 <= buffer2EnableList(3) AND NOT(clk);
    tristate4EnableBus2 <= buffer2EnableList(4) AND NOT(clk);
    tristate5EnableBus2 <= buffer2EnableList(5) AND NOT(clk);
    tristate6EnableBus2 <= buffer2EnableList(6) AND NOT(clk);
    tristate7EnableBus2 <= buffer2EnableList(7) AND NOT(clk);

    -- tristates for bus 1
    tristate0bus1 : TriStateBuffer GENERIC MAP(32) PORT MAP(tristate0EnableBus1, tristate0InputBus1, dataBus1);
    tristate1bus1 : TriStateBuffer GENERIC MAP(32) PORT MAP(tristate1EnableBus1, tristate1InputBus1, dataBus1);
    tristate2bus1 : TriStateBuffer GENERIC MAP(32) PORT MAP(tristate2EnableBus1, tristate2InputBus1, dataBus1);
    tristate3bus1 : TriStateBuffer GENERIC MAP(32) PORT MAP(tristate3EnableBus1, tristate3InputBus1, dataBus1);
    tristate4bus1 : TriStateBuffer GENERIC MAP(32) PORT MAP(tristate4EnableBus1, tristate4InputBus1, dataBus1);
    tristate5bus1 : TriStateBuffer GENERIC MAP(32) PORT MAP(tristate5EnableBus1, tristate5InputBus1, dataBus1);
    tristate6bus1 : TriStateBuffer GENERIC MAP(32) PORT MAP(tristate6EnableBus1, tristate6InputBus1, dataBus1);
    tristate7bus1 : TriStateBuffer GENERIC MAP(32) PORT MAP(tristate7EnableBus1, tristate7InputBus1, dataBus1);

    -- tristates for bus 2
    tristate0bus2 : TriStateBuffer GENERIC MAP(32) PORT MAP(tristate0EnableBus2, tristate0InputBus2, dataBus2);
    tristate1bus2 : TriStateBuffer GENERIC MAP(32) PORT MAP(tristate1EnableBus2, tristate1InputBus2, dataBus2);
    tristate2bus2 : TriStateBuffer GENERIC MAP(32) PORT MAP(tristate2EnableBus2, tristate2InputBus2, dataBus2);
    tristate3bus2 : TriStateBuffer GENERIC MAP(32) PORT MAP(tristate3EnableBus2, tristate3InputBus2, dataBus2);
    tristate4bus2 : TriStateBuffer GENERIC MAP(32) PORT MAP(tristate4EnableBus2, tristate4InputBus2, dataBus2);
    tristate5bus2 : TriStateBuffer GENERIC MAP(32) PORT MAP(tristate5EnableBus2, tristate5InputBus2, dataBus2);
    tristate6bus2 : TriStateBuffer GENERIC MAP(32) PORT MAP(tristate6EnableBus2, tristate6InputBus2, dataBus2);
    tristate7bus2 : TriStateBuffer GENERIC MAP(32) PORT MAP(tristate7EnableBus2, tristate7InputBus2, dataBus2);

    out0Mux <= (writeBackReg2EnableList(0) AND writeBack2Enable);
    out1Mux <= (writeBackReg2EnableList(1) AND writeBack2Enable);
    out2Mux <= (writeBackReg2EnableList(2) AND writeBack2Enable);
    out3Mux <= (writeBackReg2EnableList(3) AND writeBack2Enable);
    out4Mux <= (writeBackReg2EnableList(4) AND writeBack2Enable);
    out5Mux <= (writeBackReg2EnableList(5) AND writeBack2Enable);
    out6Mux <= (writeBackReg2EnableList(6) AND writeBack2Enable);
    out7Mux <= (writeBackReg2EnableList(7) AND writeBack2Enable);

    -- reg input (muxes)
    reg0DataIn : Mux2 GENERIC MAP(32) PORT MAP(writeBack1Data, writeBack2Data, out0Mux, reg0MuxOutput);
    reg1DataIn : Mux2 GENERIC MAP(32) PORT MAP(writeBack1Data, writeBack2Data, out1Mux, reg1MuxOutput);
    reg2DataIn : Mux2 GENERIC MAP(32) PORT MAP(writeBack1Data, writeBack2Data, out2Mux, reg2MuxOutput);
    reg3DataIn : Mux2 GENERIC MAP(32) PORT MAP(writeBack1Data, writeBack2Data, out3Mux, reg3MuxOutput);
    reg4DataIn : Mux2 GENERIC MAP(32) PORT MAP(writeBack1Data, writeBack2Data, out4Mux, reg4MuxOutput);
    reg5DataIn : Mux2 GENERIC MAP(32) PORT MAP(writeBack1Data, writeBack2Data, out5Mux, reg5MuxOutput);
    reg6DataIn : Mux2 GENERIC MAP(32) PORT MAP(writeBack1Data, writeBack2Data, out6Mux, reg6MuxOutput);
    reg7DataIn : Mux2 GENERIC MAP(32) PORT MAP(writeBack1Data, writeBack2Data, out7Mux, reg7MuxOutput);

    -- reg enables
    reg0WriteEnable <= ((writeBackReg1EnableList(0) AND writeBack1Enable) OR (writeBackReg2EnableList(0) AND writeBack2Enable));
    reg1WriteEnable <= ((writeBackReg1EnableList(1) AND writeBack1Enable) OR (writeBackReg2EnableList(1) AND writeBack2Enable));
    reg2WriteEnable <= ((writeBackReg1EnableList(2) AND writeBack1Enable) OR (writeBackReg2EnableList(2) AND writeBack2Enable));
    reg3WriteEnable <= ((writeBackReg1EnableList(3) AND writeBack1Enable) OR (writeBackReg2EnableList(3) AND writeBack2Enable));
    reg4WriteEnable <= ((writeBackReg1EnableList(4) AND writeBack1Enable) OR (writeBackReg2EnableList(4) AND writeBack2Enable));
    reg5WriteEnable <= ((writeBackReg1EnableList(5) AND writeBack1Enable) OR (writeBackReg2EnableList(5) AND writeBack2Enable));
    reg6WriteEnable <= ((writeBackReg1EnableList(6) AND writeBack1Enable) OR (writeBackReg2EnableList(6) AND writeBack2Enable));
    reg7WriteEnable <= ((writeBackReg1EnableList(7) AND writeBack1Enable) OR (writeBackReg2EnableList(7) AND writeBack2Enable));

    -- regs
    reg0 : RegFileREG GENERIC MAP(32) PORT MAP(clk, reg0WriteEnable, rst, reg0MuxOutput, reg0Output);
    reg1 : RegFileREG GENERIC MAP(32) PORT MAP(clk, reg1WriteEnable, rst, reg1MuxOutput, reg1Output);
    reg2 : RegFileREG GENERIC MAP(32) PORT MAP(clk, reg2WriteEnable, rst, reg2MuxOutput, reg2Output);
    reg3 : RegFileREG GENERIC MAP(32) PORT MAP(clk, reg3WriteEnable, rst, reg3MuxOutput, reg3Output);
    reg4 : RegFileREG GENERIC MAP(32) PORT MAP(clk, reg4WriteEnable, rst, reg4MuxOutput, reg4Output);
    reg5 : RegFileREG GENERIC MAP(32) PORT MAP(clk, reg5WriteEnable, rst, reg5MuxOutput, reg5Output);
    reg6 : RegFileREG GENERIC MAP(32) PORT MAP(clk, reg6WriteEnable, rst, reg6MuxOutput, reg6Output);
    reg7 : RegFileREG GENERIC MAP(32) PORT MAP(clk, reg7WriteEnable, rst, reg7MuxOutput, reg7Output);

    -- output regs
    register0 <= reg0Output;
    register1 <= reg1Output;
    register2 <= reg2Output;
    register3 <= reg3Output;
    register4 <= reg4Output;
    register5 <= reg5Output;
    register6 <= reg6Output;
    register7 <= reg7Output;

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