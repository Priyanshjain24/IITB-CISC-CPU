library std;
library ieee;
use ieee.std_logic_1164.all;

entity reg_16 is
port(
  clk, rst, wr: in std_logic;
  Din: in std_logic_vector(15 downto 0);
  Dout: out std_logic_vector(15 downto 0));
end entity;

architecture reg16 of reg_16 is
  signal reg: std_logic_vector(15 downto 0) := "0000000000000000";
begin
process(clk)
  begin
    
      if(rst = '1') then
          reg <= "0000000000000000";

      else
        if(wr = '1') then
          reg <= Din;
			 Dout <= Din;
			else
			Dout <= reg;
        end if;
        
		  
		end if;
		
     
		
end process;

end reg16;
