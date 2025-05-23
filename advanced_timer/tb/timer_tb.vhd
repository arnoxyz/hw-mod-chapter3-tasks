library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;
use work.util_pkg.all;

entity timer_tb is
end entity;

--write another tb for the advanced_timer
architecture tb of timer_tb is
	constant CLK_FREQ : integer := 10; --1_000_000_000 --1GHz = 1ns --50_000_000, 50 MHZ
	constant CLK_PERIOD : time := 1 ns; --1 sec / CLK_FREQ;
	signal stop_clk : std_ulogic := '0';

  signal btn_n : std_ulogic := '1';
  signal clk : std_ulogic := '0'; 
  signal res_n : std_ulogic := '1';
  signal ssd : std_ulogic_vector(6 downto 0);
begin
  --UUT
  UUT : entity work.timer(beh) 
  generic map(
    CLK_FREQ => CLK_FREQ
  )
  port map(
    btn_n => btn_n,
    clk   => clk,
    res_n => res_n,
    ssd   => ssd
  );

  --clk_gen 
  clk_gen : process is 
  begin 
    wait for clk_period / 2;
    clk <= '0';
    wait for clk_period / 2;
    clk <= '1';

    if stop_clk = '1' then 
      wait;
    end if;
  end process;

  --stimuli
  stim :  process is 
  begin 
    report "begin sim";
    res_n <= '0'; 
    wait for 2*CLK_PERIOD;

    res_n <= '1';
    wait for 2*CLK_PERIOD;

    btn_n <= '0';
    wait for 2*CLK_PERIOD;
    btn_n <= '1';
    wait for 200*CLK_PERIOD;

    stop_clk <= '1';
    wait for 1 ns;
    wait until ssd = SSD_CHAR_OFF;
    report "end sim";
    wait;
  end process;
end architecture;

architecture tb2 of timer_tb is 
    constant CLK_FREQ : integer := 100; --50_000_000; 
    constant clk_period : time := 1 sec / CLK_FREQ;

    signal btn_n    : std_ulogic := '1'; 
    signal clk      : std_ulogic := '0';
    signal res_n    : std_ulogic := '1'; 
    signal ssd      : std_ulogic_vector(6 downto 0) := SSD_CHAR_OFF;

    signal clk_stop : std_ulogic := '0';
begin 
  --UUT
  UUT : entity work.timer(beh2)
  generic map( CLK_FREQ => CLK_FREQ)
  port map(btn_n => btn_n, clk => clk, res_n => res_n, ssd => ssd);

  --CLK_GEN
  clk_gen : process is 
  begin 
    wait for clk_period / 2;
    clk <= '0'; 
    wait for clk_period / 2;
    clk <= '1'; 

    if clk_stop = '1' then 
      wait;
    end if;
  end process;

  --Stimuli
  stimuli : process is
  begin 
    report "sim start";
    res_n <= '0'; 
    wait for 2*clk_period;

    res_n <= '1';
    wait for 2*clk_period;

    btn_n <= '0';
    wait for 10*clk_period;
    btn_n <= '1';
    wait for 10*clk_period;

    --wait for 1000*clk_period;
    wait until ssd = SSD_CHAR_OFF;

    clk_stop <= '1';
    report "sim done";
    wait;
  end process;
end architecture;
