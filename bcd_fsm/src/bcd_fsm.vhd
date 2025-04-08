library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.util_pkg.all;
--for exercise I just implement a smaller version withouth the signed_mode 

entity bcd_fsm is
	port(
		clk         : in std_ulogic;
		res_n       : in std_ulogic;
		input_data  : in std_ulogic_vector(15 downto 0);
		hex_digit1     : out std_ulogic_vector(6 downto 0);
		hex_digit10    : out std_ulogic_vector(6 downto 0);
		hex_digit100   : out std_ulogic_vector(6 downto 0);
		hex_digit1000  : out std_ulogic_vector(6 downto 0);
    --signed_mode : in std_ulogic;
    --hex_sign       : out std_ulogic_vector(6 downto 0)
	);
end entity;

architecture beh of bcd_fsm is
begin
end architecture;
