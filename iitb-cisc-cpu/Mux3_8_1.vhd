library ieee;
use ieee.std_logic_1164.all;
--library work;
--use work.Gates.all;

-- Begin entity
entity Mux3_8_1 is
port( A, B, C, D, E, F, G, H : in std_logic_vector(2 downto 0);
		S : in std_logic_vector(2 downto 0);
		y : out std_logic_vector(2 downto 0) );
end Mux3_8_1;


-- Begin architecture
architecture behave of Mux3_8_1 is
-- Define components
component mux_eight_to_one is
	port(A,B,C,D,E,F,G,H : in std_logic; 
	S : in std_logic_vector(2 downto 0);
	Z: out std_logic);
end component;
begin 
	muxg4: for i in 2 downto 0 generate
		mx: mux_eight_to_one port map(A => A(i),B => B(i),C => C(i),D => D(i), E => E(i), F => F(i), G => G(i), H => H(i), S => S,z => y(i));
	end generate muxg4;
end behave;