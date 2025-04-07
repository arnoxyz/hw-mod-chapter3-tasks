library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;

entity traffic_light is
	generic (
		WAIT_TIME : integer;
		CLK_FREQ  :  integer
	);
	port (
		clk        : in std_ulogic;
		res_n      : in std_ulogic;
    btn_n      : in std_ulogic; --low active btn for pedestrian
    pl         : out std_ulogic_vector(1 downto 0); --(green, red), pl=pedestrian light (pedestrian traffic light)
    tl         : out std_ulogic_vector(2 downto 0) --(green, yellow, red), tl=traffic light (car traffic light)
	);
end entity;

architecture beh of traffic_light is 
  --state names are of the perspective of the car traffic light
  type fsm_state_t is (IDLE, BLINK_GREEN_ON, BLINK_GREEN_OFF, YELLOW1, RED, YELLOW2);
  type fsm_reg_t is record
    state : fsm_state_t;
    sec_cnt : unsigned(2 downto 0);
    clk_cnt : unsigned(log2c(CLK_FREQ)-1 downto 0);
  end record;
  signal s, s_nxt : fsm_reg_t;
  constant INIT_VAL : fsm_reg_t := (state=>IDLE, sec_cnt=>(others=>'0'), clk_cnt=>(others=>'0'));
begin 

  sync : process(clk, res_n) is 
  begin 
    if res_n = '0' then 
      s <= INIT_VAL; 
    elsif rising_edge(clk) then 
      s <= s_nxt;
    end if;
  end process;
  
  comb : process(all) is 
  begin 
    s_nxt <= s;
    pl <= "01"; 
    tl <= "100";

    case s.state is 
      when IDLE =>
        if btn_n = '0' then 
          s_nxt.state <= BLINK_GREEN_ON;
        end if;

      when BLINK_GREEN_ON=>
        s_nxt.clk_cnt <= s.clk_cnt + 1;

        if to_integer(s.sec_cnt) >= 8 then 
          s_nxt.state <= YELLOW1;
          s_nxt.clk_cnt <= (others => '0');
          s_nxt.sec_cnt <= (others => '0');
        end if;

        if s.clk_cnt >= CLK_FREQ then 
          s_nxt.state <= BLINK_GREEN_OFF;
          s_nxt.sec_cnt <= s_nxt.sec_cnt + 1;
          s_nxt.clk_cnt <= (others => '0');
        end if;

      when BLINK_GREEN_OFF=>
        s_nxt.clk_cnt <= s.clk_cnt + 1;
        tl <= "000";

        if s.clk_cnt >= CLK_FREQ then 
          s_nxt.state <= BLINK_GREEN_ON;
          s_nxt.sec_cnt <= s_nxt.sec_cnt + 1;
          s_nxt.clk_cnt <= (others => '0');
        end if;

      when YELLOW1=>
      tl <= "010";
      s_nxt.clk_cnt <= s.clk_cnt + 1;

      if to_integer(s.sec_cnt) >= WAIT_TIME then 
        s_nxt.state <= RED;
        s_nxt.clk_cnt <= (others => '0');
        s_nxt.sec_cnt <= (others => '0');
      end if;

      if s.clk_cnt >= CLK_FREQ then 
        s_nxt.sec_cnt <= s_nxt.sec_cnt + 1;
        s_nxt.clk_cnt <= (others => '0');
      end if;

      when RED=>
      pl <= "10"; 
      tl <= "001";

      if to_integer(s.sec_cnt) >= WAIT_TIME then 
        s_nxt.state <= YELLOW2;
        s_nxt.clk_cnt <= (others => '0');
        s_nxt.sec_cnt <= (others => '0');
      end if;

      if s.clk_cnt >= CLK_FREQ then 
        s_nxt.sec_cnt <= s_nxt.sec_cnt + 1;
        s_nxt.clk_cnt <= (others => '0');
      end if;

      when YELLOW2=>
      pl <= "01"; 
      tl <= "010";

      if to_integer(s.sec_cnt) >= WAIT_TIME then 
        s_nxt.state <= IDLE;
        s_nxt.clk_cnt <= (others => '0');
        s_nxt.sec_cnt <= (others => '0');
      end if;

      if s.clk_cnt >= CLK_FREQ then 
        s_nxt.sec_cnt <= s_nxt.sec_cnt + 1;
        s_nxt.clk_cnt <= (others => '0');
      end if;
    end case;
  end process;
end architecture;
