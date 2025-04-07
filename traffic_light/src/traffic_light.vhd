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
end architecture;
