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
		hex_digit1     : out std_ulogic_vector(6 downto 0); --HEX1
		hex_digit10    : out std_ulogic_vector(6 downto 0); --HEX2
		hex_digit100   : out std_ulogic_vector(6 downto 0); --HEX3
		hex_digit1000  : out std_ulogic_vector(6 downto 0)  --HEX4
	);
end entity;

architecture beh of bcd_fsm is
  type fsm_state_t is (IDLE, SUB1, SUB2, SUB3, SUB4);
  type fsm_reg_t is record 
    state : fsm_state_t;
    data : std_ulogic_vector(15 downto 0);
    data_nxt : std_ulogic_vector(15 downto 0);
    hex1 : std_ulogic_vector(6 downto 0);
    hex2 : std_ulogic_vector(6 downto 0);
    hex3 : std_ulogic_vector(6 downto 0);
    hex4 : std_ulogic_vector(6 downto 0);
  end record;

  constant RESET_VAL : fsm_reg_t := (state => IDLE, others => (others => '0'));
  signal s : fsm_reg_t := RESET_VAL;
  signal s_nxt : fsm_reg_t;
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
    s_nxt.data <= input_data;
    s_nxt.data_nxt <= s.data;
    hex_digit1 <= s.hex1;
    hex_digit10 <= s.hex2;
    hex_digit100 <= s.hex3;
    hex_digit1000 <= s.hex4;

    case s.state is 
      when IDLE => 
        if unsigned(s.data) /= unsigned(s.data_nxt) then 
          s_nxt.data <= input_data; --sample input data
          s_nxt.state <= SUB1;
        end if;

      when SUB1 => 
        --sub 1000, to get digit1000 and save it into hex4
        if unsigned(s.data) < 1000 then 
          s_nxt.state <= SUB2; 
        else 
          s_nxt.data <= std_ulogic_vector(unsigned(s.data) - 1000);
          s_nxt.hex4 <= std_ulogic_vector(unsigned(s.hex4) + 1);
        end if;

      when SUB2 => 
        --sub 100, to get digit100 and save it into hex3
        if unsigned(s.data) < 100 then 
          s_nxt.state <= SUB3; 
        else 
          s_nxt.data <= std_ulogic_vector(unsigned(s.data) - 100);
          s_nxt.hex3 <= std_ulogic_vector(unsigned(s.hex3) + 1);
        end if;

      when SUB3 => 
        --sub 10, to get digit10 and save it into hex2
        if unsigned(s.data) < 10 then 
          s_nxt.state <= SUB4; 
        else 
          s_nxt.data <= std_ulogic_vector(unsigned(s.data) - 10);
          s_nxt.hex2 <= std_ulogic_vector(unsigned(s.hex2) + 1);
        end if;

      when SUB4 => 
        --sub 1, to get digit1 and save it into hex1
        if unsigned(s.data) < 1 then 
          s_nxt.state <= IDLE; 
        else 
          s_nxt.data <= std_ulogic_vector(unsigned(s.data) - 1);
          s_nxt.hex1 <= std_ulogic_vector(unsigned(s.hex1) + 1);
        end if;
    end case;
  end process;
end architecture;
