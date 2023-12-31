library ieee;
use ieee.std_logic_1164.all;
--library work;
--use work.Gates.all;

-- Begin entity
entity Mux16_2_1 is
port( A, B : in std_logic_vector(15 downto 0);
		S : in std_logic;
		y : out std_logic_vector(15 downto 0) );
end Mux16_2_1;


-- Begin architecture
architecture behave of Mux16_2_1 is
-- Define components
component mux_two_to_one is 
	port( A, B, S : in std_logic;
			Z : out std_logic );
end component;
begin 
	muxg: for i in 15 downto 0 generate
		mx: mux_two_to_one port map(A => A(i),B => B(i), S => S, z => y(i));
	end generate muxg;
end behave;