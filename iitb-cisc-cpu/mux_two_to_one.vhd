library ieee;
use ieee.std_logic_1164.all;
 
entity mux_two_to_one is
	port(A,B,S: in std_logic; Z: out std_logic);
end mux_two_to_one;
 
architecture Struct of mux_two_to_one is
begin

	process(A,B,S) is
	begin
	  if (S ='0') then Z <= A;
	  else Z <= B;
	  end if; 
	end process;

end Struct;