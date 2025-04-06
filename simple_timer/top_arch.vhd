library ieee;
use ieee.std_logic_1164.all;
use work.math_pkg.all;

architecture arch of top is
	constant N : positive := 8;
begin

	testUnit : entity work.timer(beh)
	generic map (
    N => N
	)
	port map (
		clk    => clk,
		res_n  => keys(0),
		en     => keys(1),
		tick   => ledg(0)
	);

end architecture;
