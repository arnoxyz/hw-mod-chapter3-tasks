library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;
use work.util_pkg.all;



entity timer is
  port(
    btn_n   : in std_ulogic; 
    clk     : in std_ulogic;
    res_n   : in std_ulogic; 
    ssd     : out std_ulogic_vector(6 downto 0)
  );
end entity;

architecture beh of timer is
  type state_t is (IDLE, DELAY, TICK);  
  type record_t is record 
    state : state_t;
    clk_cnt : unsigned(7 downto 0);
    sec_cnt : std_ulogic_vector(3 downto 0);
  end record;
  
  signal s, s_nxt : record_t;
  constant reset_val : record_t := (state => IDLE, clk_cnt => (others=>'0'), sec_cnt => (others=>'0'));
begin 
  
  sync : process(clk, res_n) is 
  begin 
    if res_n = '0' then 
      s <= reset_val;
    elsif rising_edge(clk) then 
      s <= s_nxt;
    end if;
  end process; 


  comb : process(all) is 
  begin 
    s_nxt <= s;
    ssd <= to_segs(s.sec_cnt); 

    case s.state is
      when IDLE =>
      when DELAY =>
      when TICK =>
    end case;
  end process;
end architecture;
