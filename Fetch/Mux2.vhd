library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mux2 is
    port (
        a : in std_logic;
        b : in std_logic;
        selector: in std_logic;
        output:out std_logic
    );
end Mux2;

architecture ArchMux2 of Mux2 is

begin
output <= a when selector ='0' else b; 

end architecture;