library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.util_pkg.all;

entity bcd_fsm_tb is
end entity;

architecture tb of bcd_fsm_tb is
  constant CLK_FREQ : integer := 10000;
  constant CLK_PERIOD : time := 1 sec / clk_freq; 

  signal clk_stop : std_ulogic := '0';
	signal clk : std_ulogic := '0';
  signal res_n : std_ulogic := '1';
	signal input_data : std_ulogic_vector(15 downto 0);
	signal signed_mode : std_ulogic;
	signal hex_digit1000, hex_digit100, hex_digit10, hex_digit1, hex_sign: std_ulogic_vector(6 downto 0);

begin

	uut : entity work.bcd_fsm(beh)
		port map (
			clk           => clk,
			res_n         => res_n,
			input_data    => input_data,
			hex_digit1000 => hex_digit1000,
			hex_digit100  => hex_digit100,
			hex_digit10   => hex_digit10,
			hex_digit1    => hex_digit1
		);

	clk_gen : process
	begin
    wait for CLK_PERIOD / 2;    
    clk <= '0';
    wait for CLK_PERIOD / 2;    
    clk <= '1';

    if clk_stop = '1' then 
      wait;
    end if;
	end process;

	stimulu : process
	begin
    report "sim start";
    res_n <= '0';
    wait;
	end process;
end architecture;
