library ieee;
use ieee.std_logic_1164.all;

entity Penc_8_3 is
port (
clk: in std_logic;
input: in std_logic_vector(15 downto 0);
bin: out std_logic_vector(2 downto 0);
output: out std_logic_vector(15 downto 0);
v : out std_logic:= '0'
);
end entity;


architecture tech of Penc_8_3 is
begin

process(clk)

begin
v <= '0';
if (input(7) = '1') then
bin <= "111";
output <= input(15 downto 8)&'0'&input(6 downto 0);
elsif (input(6) = '1') then
bin <= "110";
output <= input(15 downto 8)&input(7 downto 7)&'0'&input(5 downto 0);
elsif (input(5) = '1') then
bin <= "101";
output <= input(15 downto 8)&input(7 downto 6)&'0'&input(4 downto 0);
elsif (input(4) = '1') then
bin <= "100";
output <= input(15 downto 8)&input(7 downto 5)&'0'&input(3 downto 0);
elsif (input(3) = '1') then
bin <= "011";
output <= input(15 downto 8)&input(7 downto 4)&'0'&input(2 downto 0);
elsif (input(2) = '1') then
bin <= "010";
output <= input(15 downto 8)&input(7 downto 3)&'0'&input(1 downto 0);
elsif (input(1) = '1') then
bin <= "001";
output <= input(15 downto 8)&input(7 downto 2)&'0'&input(0 downto 0);
elsif (input(0) = '1') then
bin <= "000";
output <= input(15 downto 8)&input(7 downto 1)&'0';
else
v <= '1';
end if;

end process;
end architecture;