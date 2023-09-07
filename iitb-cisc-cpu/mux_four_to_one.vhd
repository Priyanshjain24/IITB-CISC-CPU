library ieee;
use ieee.std_logic_1164.all;
 
entity mux_four_to_one is
	port(A,B,C,D : in std_logic; 
	S : in std_logic_vector(1 downto 0);
	Z: out std_logic);
end mux_four_to_one;
 
architecture Struct of mux_four_to_one is
begin

	process(A,B,C,D,S) is
	begin
	  if (S(0) ='0' and S(1) = '0') then Z <= A;
	  elsif (S(0) ='1' and S(1) = '0') then Z <= B;
	  elsif (S(0) ='0' and S(1) = '1') then Z <= C;
	  else Z <= D;
	  end if; 
	end process;

end Struct;