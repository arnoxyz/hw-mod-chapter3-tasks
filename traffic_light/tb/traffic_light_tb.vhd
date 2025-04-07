library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;

entity traffic_light_tb is
end entity;

architecture tb of traffic_light_tb is
  constant CLK_FREQ : integer := 10;
  constant WAIT_TIME : integer := 10;

  signal clk : std_ulogic := '0';
  signal clk_period : time := 1 sec / CLK_FREQ; 
  signal clk_stop : std_ulogic := '0';

	signal res_n : std_ulogic := '1';
  signal btn_n : std_ulogic := '1'; --low active btn for pedestrian
  signal pl : std_ulogic_vector(1 downto 0); --(green, red), pl=pedestrian light (pedestrian traffic light)
  signal tl : std_ulogic_vector(2 downto 0); --(green, yellow, red), tl=traffic light (car traffic light)

begin
  uut : entity work.traffic_light(beh)
  generic map(CLK_FREQ=>CLK_FREQ, WAIT_TIME=>WAIT_TIME)
  port map(clk=>clk, res_n=>res_n, btn_n=>btn_n, pl=>pl, tl=>tl);

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

  stim : process is 
  begin 
    report "start sim";
    res_n <= '0';
    wait for 2*clk_period;
    res_n <= '1';
    wait for 2*clk_period;
    btn_n<= '0';
    wait for 5*clk_period;
    btn_n<= '1';
    wait for 5*clk_period;
    
    wait until pl = "10";
    report "pl should be now red";
    wait until tl = "100";
    report "now it should be in the IDLE state again";
    wait for 5*clk_period;
    clk_stop <= '1';
    report "end sim";
    wait;
  end process;
end architecture;
