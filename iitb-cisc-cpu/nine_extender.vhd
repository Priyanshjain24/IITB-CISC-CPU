library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nine_extender is
  port (A: in std_logic_vector(8 downto 0); B: out std_logic_vector(15 downto 0));
end entity nine_extender;

architecture Struct of nine_extender is
begin
	
	process(A)
	begin
	if(A(8) = '0') then B <= "0000000" & A;
	else B <= "1111111" & A;
	end if;
	end process;
	
end Struct;