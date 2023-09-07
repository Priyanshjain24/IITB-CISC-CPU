library ieee;
use ieee.std_logic_1164.all;
 
entity mux_eight_to_one is
	port(A,B,C,D,E,F,G,H: in std_logic; S: in std_logic_vector(2 downto 0);Z: out std_logic);
end mux_eight_to_one;
 
architecture Struct of mux_eight_to_one is
begin

	process(A,B,C,D,E,F,G,H,S) is
	begin
	  if (S(0) ='0' and S(1) = '0' and S(2) = '0') then Z <= A;
	  elsif (S(0) ='1' and S(1) = '0' and S(2) = '0') then Z <= B;
	  elsif (S(0) ='0' and S(1) = '1' and S(2) = '0') then Z <= C;
	  elsif (S(0) ='1' and S(1) = '1' and S(2) = '0') then Z <= D;     
	  elsif (S(0) ='0' and S(1) = '0' and S(2) = '1') then Z <= E;
	  elsif (S(0) ='1' and S(1) = '0' and S(2) = '1') then Z <= F;    
	  elsif (S(0) ='0' and S(1) = '1' and S(2) = '1') then Z <= G;
	  else Z <= H;
	  end if;
	end process;

end Struct;