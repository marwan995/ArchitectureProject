library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

entity AluToDecodeForwarding is
  port (
        regDest: IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        aluRegAlu : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluRegImmedate : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluRegSrc1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluRegSrc2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        forwardAluSelector : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        aluForwardEnable : IN STD_LOGIC;

        forwardOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  ) ;
end AluToDecodeForwarding ; 

architecture arch of AluToDecodeForwarding is
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
    SIGNAL aluValue: STD_LOGIC_VECTOR(31 DOWNTO 0);
begin
    aluValuesMux : Mux4 GENERIC MAP(
        32)PORT MAP(
        aluRegALu, aluRegImmedate, aluRegSrc1, aluRegSrc2, forwardAluSelector , aluValue
    );

    aluForwardingMux : Mux2 GENERIC MAP(
        32)PORT MAP(
            regDest, aluValue, aluForwardEnable, forwardOut
    );
end architecture ;