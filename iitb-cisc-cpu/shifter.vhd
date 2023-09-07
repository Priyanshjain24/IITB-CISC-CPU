library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter is
	port (A: in std_logic_vector(8 downto 0); B: out std_logic_vector(15 downto 0));
end shifter;

architecture Struct of shifter is 
begin
	B <= A & "0000000";
end Struct;
