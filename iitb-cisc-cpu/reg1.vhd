library std;
library ieee;
use ieee.std_logic_1164.all;

entity reg_1 is
port(
  clk, rst, wr: in std_logic;
  Din: in std_logic;
  Dout: out std_logic);
end entity;

architecture reg1 of reg_1 is
  signal reg: std_logic:= '0';
begin
process(clk)
  begin
    if(clk = '1' and clk'event) then
      if(rst = '1') then
          reg <= '0';

      else
        if(wr = '1') then
          reg <= Din;
        end if;
        
		end if;
		
      end if;
		Dout <= reg;
end process;

end reg1;
