library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
  port (D: out std_logic_vector(7 downto 0); A, B, C: in std_logic);
end entity decoder;

architecture Struct of decoder is
begin
	D(0) <= not(A) or not(B) or not(C);
	D(1) <= not(A) or not(B) or C;
	D(2) <= not(A) or B or not(C);
	D(3) <= not(A) or B or C;
	D(4) <= A or not(B) or not(C);
	D(5) <= A or not(B) or C;
	D(6) <= A or B or not(C);
	D(7) <= A or B or C;
end Struct;
