library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_signal_generator is
	generic (
		COUNTER_WIDTH : integer := 8
	);
	port (
		clk        : in std_ulogic;
		res_n      : in std_ulogic;
		en         : in std_ulogic;
		value      : in std_ulogic_vector(COUNTER_WIDTH-1 downto 0);
		pwm_out    : out std_ulogic
	);
end entity;


architecture arch of pwm_signal_generator is
begin

	sync : process(clk, res_n)
		variable counter_reg : unsigned(COUNTER_WIDTH-1 downto 0) := (others => '0');
		variable active : std_ulogic := '0';
	begin
		pwm_out <= '0';

		--async reset
		if (res_n = '0') then
			counter_reg := (others => '0');
			active := '0';
		elsif rising_edge(clk) then
			if counter_reg = 0 and en = '1' then 
				active := '1';
			end if;

			if active = '1' then 
				if counter_reg >= unsigned(value) then 
					pwm_out <= '1';
				end if;
			end if;

			counter_reg := counter_reg + 1;
		end if;
	end process;
end architecture;
