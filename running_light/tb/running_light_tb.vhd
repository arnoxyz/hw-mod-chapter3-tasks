library ieee;
use ieee.std_logic_1164.all;

entity running_light_tb is
end entity;

architecture tb of running_light_tb is
		constant WAIT_TIME  : time := 1 ns;
		constant CLK_FREQ   : integer := 50_000_000; --5_000_000; 
    constant CLK_PERIOD : time := 1 ns; --1 sec / CLK_FREQ;
    signal clk_stop : std_ulogic := '0';

		signal clk      : std_ulogic := '0';
		signal res_n    : std_ulogic := '1';
		signal leds     : std_ulogic_vector(7 downto 0) := (others=>'0');
begin
  --UUT
  UUT : entity work.running_light(beh)
  generic map(WAIT_TIME=>WAIT_TIME,CLK_FREQ=>CLK_FREQ)
  port map(clk=>clk, res_n=>res_n, leds=>leds);

  --clk_gen
  clk_gen : process is 
  begin 
    wait for CLK_PERIOD / 2;
    clk <= '0';
    wait for CLK_PERIOD / 2;
    clk <= '1';

    if clk_stop = '1' then 
      wait;
    end if;
  end process;

  --stimuli
  stimuli : process is 
  begin 
    report "sim start";
    res_n <= '0';
    wait for 2*CLK_PERIOD;
    res_n <= '1';
    wait for 1000 ns;

    clk_stop <= '1';
    report "sim done";
    wait;
  end process;
end architecture;
