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
		hex_digit1     : out std_ulogic_vector(6 downto 0); --HEX4
		hex_digit10    : out std_ulogic_vector(6 downto 0); --HEX3
		hex_digit100   : out std_ulogic_vector(6 downto 0); --HEX2
		hex_digit1000  : out std_ulogic_vector(6 downto 0)  --HEX1
	);
end entity;

architecture beh of bcd_fsm is
  type fsm_state_t is (IDLE, SUB1, SUB2, SUB3, SUB4);
  type fsm_reg_t is record 
    state : fsm_state_t;
    data : std_ulogic_vector(15 downto 0);
    hex1 : std_ulogic_vector(6 downto 0);
    hex2 : std_ulogic_vector(6 downto 0);
    hex3 : std_ulogic_vector(6 downto 0);
    hex4 : std_ulogic_vector(6 downto 0);
  end record;

  signal s, s_nxt : fsm_reg_t;
  constant RESET_VAL : fsm_reg_t := (state => IDLE, others => (others => '0'));
begin
end architecture;
