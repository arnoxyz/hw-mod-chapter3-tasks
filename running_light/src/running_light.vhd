library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;

entity running_light is
	generic (
		STEP_TIME  : time := 1 sec
	);
	port (
		clk      : in std_ulogic;
		res_n    : in std_ulogic;
		leds     : out std_ulogic_vector
	);
end entity;

architecture arch of running_light is
	constant LEDS_WIDTH : natural := 8;

	type fsm_state_t is (IDLE, A, B); 
	signal state, state_next: fsm_state_t;
	signal leds_internal : std_ulogic_vector(LEDS_WIDTH-1 downto 0) := (others=>'0');
	signal leds_internal_next : std_ulogic_vector(LEDS_WIDTH-1 downto 0) := (others=>'0');
begin

	registers: process(clk, res_n) is
		variable counter : integer := 0;
		variable threshold : integer := 0;
	begin
		if (res_n = '0') then
			state <= IDLE;

		elsif rising_edge(clk) then
			threshold := STEP_TIME / 20 ns;

			if(counter = threshold) then
				leds_internal <= leds_internal_next;
				leds <= leds_internal;
				state <= state_next;
				counter := 0;
			else 
				counter := counter + 1;
			end if;
		end if;
	end process;

	-- Implement next state and output logic for your pattern
	comb_logic : process(all) is
	begin
		state_next <= state;

		case state is
			when IDLE => 
				leds_internal_next <= (others => '0');
				state_next <= A;

			when A =>
				leds_internal_next(LEDS_WIDTH-1) <= '1'; 
				state_next <= B;

			when B =>
				leds_internal_next <= std_ulogic_vector(shift_right((unsigned(leds_internal)),1)); 

				if(leds(0) = '1') then 
					state_next <= IDLE;
				end if;
		end case;
	end process;
end architecture;

