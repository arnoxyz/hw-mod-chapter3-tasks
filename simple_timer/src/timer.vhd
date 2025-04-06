library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;


entity timer is
	generic (
        N : positive := 8     
    );
	port (
        clk     : in std_ulogic;
        res_n   : in std_ulogic;
        en      : in std_ulogic; 
        tick    : out std_ulogic
    );
end entity;

architecture beh of timer is
begin
end architecture;
