library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity six_extender is
  port (A: in std_logic_vector(5 downto 0); B: out std_logic_vector(15 downto 0));
end entity six_extender;

architecture Struct of six_extender is
begin
	
	process(A)
	begin	
	if(A(5) = '0') then B <= "0000000000" & A;
	else B <= "1111111111" & A;
	end if;
	end process;
	
end Struct;