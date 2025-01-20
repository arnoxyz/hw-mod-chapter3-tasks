library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_signal_generator_tb is
end entity;

architecture tb of pwm_signal_generator_tb is
	constant COUNTER_WIDTH : integer := 2; --8; -- Define the counter width
	constant CLK_PERIOD : time := 2 ns; --1000 ns; --50MHz = 20 ns, 1MHz = 1000 ns
	signal stop_clk : boolean := false;
	signal clk, res_n, en : std_ulogic := '0';
	signal value : std_ulogic_vector(COUNTER_WIDTH-1 downto 0) := (others=>'0');
	signal pwm_out : std_ulogic;
begin

	dut : entity work.pwm_signal_generator
		generic map (
			COUNTER_WIDTH => COUNTER_WIDTH
		)
		port map (
			clk     => clk,
			res_n   => res_n,
			en      => en,
			value   => value,
			pwm_out => pwm_out
		);

	clk_process : process
	begin
		--Generate a 1 MHz clock signal
		clk <= '0';
		wait for CLK_PERIOD/2;
		clk <= '1';
		wait for CLK_PERIOD/2;
		if stop_clk = true then 
			wait;
		end if;
	end process;

	stimulus_process : process
		procedure check_pwm_signal(low_time, high_time : time) is
			variable start_time, switch_time, end_time : time;
			variable local_low_time, local_high_time : time;
		begin
			--get the timestamps
			wait until falling_edge(pwm_out);
			start_time := now;

			wait until rising_edge(pwm_out);
			switch_time := now;

			wait until falling_edge(pwm_out);
			end_time := now;

			local_low_time := switch_time - start_time;
			local_high_time := end_time - switch_time;

			assert local_low_time = low_time report "error in low_time" & to_string(local_low_time) & "!=" & to_string(low_time);
			assert local_high_time = high_time report "error in high_time" & to_string(local_high_time) & "!=" & to_string(high_time);
		end procedure;

		procedure check_deassertion(low_time, high_time : time) is 
			variable start_time, switch_time, end_time : time;
			variable local_low_time, local_high_time : time;
		begin
			--get the timestamps
			wait until falling_edge(pwm_out);
			start_time := now;

			--deassert en in pwm cycle should have no difference in the outcome
			wait for CLK_PERIOD;
			en <= '0';

			wait until rising_edge(pwm_out);
			switch_time := now;

			wait until falling_edge(pwm_out);
			end_time := now;

			local_low_time := switch_time - start_time;
			local_high_time := end_time - switch_time;

			assert local_low_time = low_time report "error in low_time (deasserting en)" & to_string(local_low_time) & "!=" & to_string(low_time);
			assert local_high_time = high_time report "error in high_time (deasserting en)" & to_string(local_high_time) & "!=" & to_string(high_time);
		end procedure;

		procedure check_value(current_value : std_ulogic_vector(COUNTER_WIDTH - 1 downto 0); deassertion : std_ulogic) is 
			constant max_val : std_ulogic_vector(COUNTER_WIDTH-1 downto 0) := (others => '1');
			--low time value: current_value 
			constant low_time_int : integer := to_integer(unsigned(current_value));
			--high time value: max_value+1 - current_value
			constant high_time_int : integer := to_integer(unsigned(max_val)+1 - (unsigned(current_value)));

			constant low_time : time := low_time_int * CLK_PERIOD;
			constant high_time : time := high_time_int * CLK_PERIOD;
		begin 
			--reset
			res_n <= '1';
			en <= '0';
			value <= current_value;
			wait for CLK_PERIOD;

			--start
			res_n <= '0';
			wait for CLK_PERIOD;
			en <= '1';
			wait for CLK_PERIOD;

			if deassertion= '0' then 
				check_pwm_signal(low_time, high_time);
			else 
				check_deassertion(low_time, high_time);
			end if;
		end procedure;

	begin
			-- Implement the test cases
			report "start sim";

			-- Test1: loop thorugh all values of value and check pwm_signal is correct
			for val in 1 to 2**(COUNTER_WIDTH-1) loop
				--report "val: " & to_string(val);
				report "sim with value: " & to_string(val);
				check_value(std_ulogic_vector(to_unsigned(val, COUNTER_WIDTH)), '0');
			end loop;

			-- Test2: deassert en while a PWM is being generated
			-- for val in 0 to 2**(COUNTER_WIDTH-1) loop
			-- 	check_value(std_ulogic_vector(to_unsigned(val, COUNTER_WIDTH)), '1');
			-- end loop;
			
			stop_clk <= true;
			
			report "sim done";
			wait;
	end process;
end architecture;
