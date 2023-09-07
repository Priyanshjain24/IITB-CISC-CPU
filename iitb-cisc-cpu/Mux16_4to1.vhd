library ieee;
use ieee.std_logic_1164.all;
--library work;
--use work.Gates.all;

-- Begin entity
entity Mux16_4_1 is
port( A, B, C, D : in std_logic_vector(15 downto 0);
		S : in std_logic_vector(1 downto 0);
		y : out std_logic_vector(15 downto 0) );
end Mux16_4_1;


-- Begin architecture
architecture behave of Mux16_4_1 is
-- Define components
component mux_four_to_one is 
	port(A,B,C,D : in std_logic; 
	S : in std_logic_vector(1 downto 0);
	Z: out std_logic);
end component;
begin 
	muxg4: for i in 15 downto 0 generate
		mx: mux_four_to_one port map(A => A(i),B => B(i),C => C(i),D => D(i),S => S,z => y(i));
	end generate muxg4;
end behave;