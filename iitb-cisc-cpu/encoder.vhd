library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity encoder is
  port (A: in std_logic_vector(7 downto 0); Y2, Y1, Y0, V: out std_logic);
end entity encoder;

architecture Struct of encoder is
begin
	Y2 <= A(4) OR A(5) OR A(6) OR A(7);
	Y1 <= A(2) OR A(3) OR A(6) OR A(7);
	Y0 <= A(1) OR A(3) OR A(5) OR A(7);
	V <= A(0) OR A(1) OR A(2) OR A(3) OR A(4) OR A(5) OR A(6) OR A(7);
end Struct;
