library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Fetch is
    port (
        clk : in std_logic;
        rst : in std_logic;
        freeze :in std_logic;
        call_rti_flag : in std_logic;
        jmpPc : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
        memPc : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
        fetchOut: out  STD_LOGIC_VECTOR(15 DOWNTO 0);
        pcOut: out  STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end Fetch;

architecture ArchFetch of Fetch is

begin
    PROCESS (clk, rst)
    BEGIN
    END PROCESS;

end architecture;