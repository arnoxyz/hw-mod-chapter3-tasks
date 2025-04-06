--simple timer:  (en=enabled, N=width of the power 2 so 2^N-1 is the max number that will be counted towards)
--adds up to 2^N - 1 when en='1', if the max value is reaches so 2^N-1 then it overflows (gets back to 0) and outputs tick='1'
--timer only adds 1 per clk cycle so only synchronous adding

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;

entity timer is
	generic (
      N : positive := 4     
  );
	port (
      clk     : in std_ulogic;
      res_n   : in std_ulogic;
      en      : in std_ulogic; 
      tick    : out std_ulogic
  );
end entity;

architecture beh of timer is
  signal counter : unsigned(N-1 downto 0); 
  constant max_value : integer := 2**N-1;
begin
      reg : process(clk, res_n) is 
      begin 
        if res_n = '0' then 
            counter <= (others=>'0');  
        elsif rising_edge(clk) then 
          if en='1' then 
            counter <= counter + 1; 
          end if;
        end if;
      end process;

      comb : process(all) is 
      begin 
        tick <= '0'; 

        if en='1' and to_integer(counter)=max_value then 
          tick <= '1';
        end if;
      end process;
end architecture;



--other implementation, that uses the 3 process approach (sync_reg, next_state_logic, output_logic)
architecture beh2 of timer is
  subtype cnt_t is unsigned(N-1 downto 0);
  signal cnt, cnt_nxt : cnt_t;
  constant MAX_VALUE : positive := 2**N-1;
begin 
  reg : process(clk, res_n) is 
  begin 
      if res_n = '0' then 
        cnt <= (others=>'0'); 
      elsif rising_edge(clk) then 
        cnt <= cnt_nxt;
      end if;
  end process;

  nxt_state_logic : process(all) is 
  begin 
    cnt_nxt <= cnt_nxt;

    if en='1' then 
      cnt_nxt <= cnt + 1;
    end if;
  end process;

  output_logic : process(all) is 
  begin 
    tick <= '0';

    if en='1' and to_integer(cnt)=MAX_VALUE then 
      tick <= '1';
    end if;
  end process;
end architecture;



