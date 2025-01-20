library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.util_pkg.all;

entity bcd_fsm is
	port(
		clk         : in std_ulogic;
		res_n       : in std_ulogic;

		input_data  : in std_ulogic_vector(15 downto 0);
		signed_mode : in std_ulogic;

		hex_digit1     : out std_ulogic_vector(6 downto 0);
		hex_digit10    : out std_ulogic_vector(6 downto 0);
		hex_digit100   : out std_ulogic_vector(6 downto 0);
		hex_digit1000  : out std_ulogic_vector(6 downto 0);
		hex_sign       : out std_ulogic_vector(6 downto 0)
	);
end entity;

architecture beh of bcd_fsm is
	--Declare an fsm state enum type
	type fsm_state_t is (IDLE, A, B); 

	-- TODO: Declare a state register record type
	signal state, state_next: fsm_state_t;
begin

	sync : process(clk, res_n)
	begin
		-- TODO: Implement state register

		--reset all regs
		if (res_n = '0') then
			state <= IDLE;

		elsif rising_edge(clk) then
			state <= state_next;
		end if;
	end process;

	comb : process(all)
	begin
	-- TODO: Implement combinational logic
		state_next <= state;

		case state is
			when IDLE => 
				leds_internal_next <= (others => '0');
				state_next <= A;

			when A =>
				leds_internal_next(LEDS_WIDTH-1) <= '1'; 
				state_next <= B;

			when B =>
				leds_internal_next <= std_logic_vector(shift_right((unsigned(leds_internal)),1)); 

				if(leds(0) = '1') then 
					state_next <= IDLE;
				end if;
		end case;
	end process;

end architecture;
