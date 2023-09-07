library std;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFile is
  port(
    clk, rst, wr: in std_logic;
    A1,A2,A3: in std_logic_vector(2 downto 0); --maybe 3 addresses are not needed
	Din: in std_logic_vector(15 downto 0);
    Dout1, Dout2, pc,r: out std_logic_vector(15 downto 0));
end entity;

architecture arch of RegisterFile is
  type registers is array(0 to 7) of std_logic_vector(15 downto 0);
  signal RF: registers:= ("0000000000000001", "0000000000000010", "0000000000000011", "0000000000000100", "1000000000000000", "0000000000010000", "0000000000001110", "0000000000000000");

begin




--put Dout statement here insted if there are problems (write only when wr = 1)


process(clk)
  begin
   
--	 
--      if(rst = '1') then
--        for i in 7 to 0 loop
--          RF(i) <= "00000000000000000";
--			 end loop;

      if(wr = '1' and rst = '0') then
          RF(to_integer(unsigned(A3))) <= Din;
			 if (A1 = A3) then
			 Dout1 <= Din;
			 elsif (A2 = A3) then
			 Dout2 <= Din;
			 end if;
      end if;
        
        
     
		
		pc <= RF(7);
		r <= RF(6);
		Dout1 <= RF(to_integer(unsigned(A1)));
      Dout2 <= RF(to_integer(unsigned(A2)));
end process;
end arch;
