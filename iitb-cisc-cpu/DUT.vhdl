-- A DUT entity is used to wrap your design so that we can combine it with testbench.
-- This example shows how you can do this for the OR Gate

library ieee;
use ieee.std_logic_1164.all;

entity DUT is
    port(input_vector: in std_logic_vector(15 downto 0);
       	output_vector: out std_logic_vector(16 downto 0));
end entity;

architecture DutWrap of DUT is
   component Datapath is
		port(mem_in: in std_logic_vector(15 downto 0);
mem_out: out std_logic_vector(15 downto 0);
clk_out: out std_logic
);
	end component;
	
	component reg_16 is
port(
  clk, rst, wr: in std_logic;
  Din: in std_logic_vector(15 downto 0);
  Dout: out std_logic_vector(15 downto 0));
end component;

component clock_generator is
port (clk_out, rst : out std_logic);
end component clock_generator;

signal clk1, rst1: std_logic;

begin

   -- input/output vector element ordering is critical,
   -- and must match the ordering in the trace file!
	clk: clock_generator port map(clk1, rst1);
   add_instance: Datapath 
			port map (input_vector, output_vector(15 downto 0), output_vector(16)); 
--			output_vector(16)<= clk1;
end DutWrap;