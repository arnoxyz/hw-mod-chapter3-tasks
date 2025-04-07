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
		-- debugging via oscilloscope
		clk_cnt_lb : out std_logic_vector(7 downto 0);
		-- pedestrian traffic light
		btn_n      : in std_ulogic;
		pred       : out std_ulogic;
		pgreen     : out std_ulogic;
		-- car traffic light
		cred       : out std_ulogic;
		cyell      : out std_ulogic;
		cgreen     : out std_ulogic
	);
end entity;

--Repeat the modelling process (understand the traffic_light model)
--IDLE = no pedestraian, car traffic is just green
--after pedestrian presses the btn_n the car traffic light switches to yellow blinking
--then keeps yellow blinking for a specific time
--then switches to red and the pedestrian light switches to green for a specific time
--then it switches again to yellow blinking and the pedestrian light to red for a specific time
--then swittches to IDLE state again (pedestrian stays red and traffic light is green again)

--TODO: Implement the model (5 step process!!!)
architecture beh of traffic_light is 
begin 
end architecture;
