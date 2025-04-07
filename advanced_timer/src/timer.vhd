library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;
use work.util_pkg.all;



entity timer is
  generic(
    CLK_FREQ : integer := 50_000_000 --50_000_000 50MHz
  );
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
    clk_cnt : unsigned(log2c(CLK_FREQ) downto 0);
    sec_cnt : std_ulogic_vector(3 downto 0);
  end record;
  
  signal s, s_nxt : record_t;
  constant reset_val : record_t := (state => IDLE, clk_cnt => (others=>'0'), sec_cnt => (others=>'0'));

  constant COUNT_TO : integer := 2; --15 normally for sim 2
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
        ssd <= SSD_CHAR_OFF;
  
        if btn_n = '0' then 
          s_nxt.state <= DELAY;
        end if;

      when DELAY =>
        s_nxt.clk_cnt <= s.clk_cnt+1;

        if s.clk_cnt >= CLK_FREQ -1 then 
          s_nxt.state <= TICK;
        end if;

      when TICK =>
        s_nxt.state <= IDLE;
        s_nxt.clk_cnt <= (others=>'0');

        if unsigned(s.sec_cnt) < COUNT_TO then 
          s_nxt.sec_cnt <= std_ulogic_vector(unsigned(s.sec_cnt)+1);
          s_nxt.state <= DELAY;
        end if;
    end case;
  end process;
end architecture;



architecture beh2 of timer is 
  type fsm_state_t is (IDLE, COUNT, ADD_SEC);
  type fsm_reg_t is record
    state : fsm_state_t; 
    clk_cnt : unsigned(log2c(CLK_FREQ)-1 downto 0);
    sec_cnt : std_ulogic_vector(3 downto 0);
  end record;

  signal s, s_nxt : fsm_reg_t;
  constant RESET_VAL : fsm_reg_t := (state => IDLE, clk_cnt => (others => '0'), sec_cnt => (others => '0'));
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
    ssd <= to_segs(s.sec_cnt);

    case s.state is 
        when IDLE     => 
          ssd <= SSD_CHAR_OFF;

          if btn_n = '0' then 
            s_nxt.state <= COUNT;
          end if;

        when COUNT    => 
          s_nxt.clk_cnt <= s.clk_cnt + 1;

          if to_integer(s.clk_cnt) >= CLK_FREQ then 
            s_nxt.state <= ADD_SEC;
          end if;

        when ADD_SEC  => 
          s_nxt.clk_cnt <= (others => '0');
          s_nxt.sec_cnt <= std_ulogic_vector(unsigned(s.sec_cnt) + 1);

          if unsigned(s.sec_cnt) >= 15 then 
            s_nxt.state <= IDLE;
            s_nxt.sec_cnt <= (others => '0');
          else 
            s_nxt.state <= COUNT;
          end if; 
    end case;
  end process;
end architecture;

