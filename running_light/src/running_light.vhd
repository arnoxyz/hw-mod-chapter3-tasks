library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;

entity running_light is
	generic (
		WAIT_TIME  : time := 1 sec;
		CLK_FREQ   : integer := 50_000_000 
	);
	port (
		clk      : in std_ulogic;
		res_n    : in std_ulogic;
		leds     : out std_ulogic_vector(7 downto 0)
	);
end entity;

--implementing pattern1 with just one state (START)
architecture beh of running_light is
  type fsm_state_t is (START);
  type fsm_reg_t is record 
    state : fsm_state_t;
    clk_cnt : unsigned(log2c(CLK_FREQ)-1 downto 0);
    leds : std_ulogic_vector(7 downto 0);
  end record;

  signal s, s_nxt : fsm_reg_t; 
  constant RESET_VAL : fsm_reg_t := (state=>START, clk_cnt=>(others=>'0'), leds=>(7=>'1', others=>'0'));

  constant CLK_PERIOD : time := 1 sec / CLK_FREQ; -- 1_000_000_000 ps
  constant CC_WAIT : integer := (CLK_PERIOD / WAIT_TIME); --clock_cycles_wait, 
begin
  
  sync : process(clk, res_n) is  
  begin 
    if res_n = '0' then 
      s <= RESET_VAL;
    elsif rising_edge(clk) then 
      s <= s_nxt;
    end if;
  end process;

  comb : process(all) is 
  begin 
  s_nxt <= s;
  s_nxt.clk_cnt <= s.clk_cnt + 1;
  leds <= s.leds;

  case s.state is 
    when START   => 
      if to_integer(s.clk_cnt) >= CC_WAIT then 
        s_nxt.clk_cnt <= (others=>'0');

        --output logic
        if s.leds(0) = '1' then 
          s_nxt.leds <= (7=>'1', others=>'0'); 
        else 
          s_nxt.leds <= std_ulogic_vector(shift_right(unsigned(s.leds), 1)); 
        end if;
      end if;
  end case;
  end process;
end architecture;
