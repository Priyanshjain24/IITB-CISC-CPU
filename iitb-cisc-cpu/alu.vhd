library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	port(
		A,B: in std_logic_vector(15 downto 0);
		op: in std_logic_vector(1 downto 0);
		output: out std_logic_vector(15 downto 0);
		C,Z: out std_logic) ;
end alu;

architecture Struct of alu is 
	
------------------------------------add-------------------------------------	
	
	function add(A : in std_logic_vector (15 downto 0);
					 B : in std_logic_vector (15 downto 0))
	return std_logic_vector is
		variable sum : std_logic_vector (15 downto 0);
		variable carry : std_logic_vector (15 downto 0);
	
	begin
	
	sum(0) := A(0) xor B(0);
   carry(0) := A(0) and B(0);
		
		L1 : for i in 1 to 15 loop
			sum(i) := A(i) xor B(i) xor carry(i-1);
         carry(i) := (A(i) and B(i)) or (carry(i-1) and (A(i) or B(i)));
      end loop L1 ;
   return carry (15) & sum ;
	end add;
	
-------------------------------subtract-----------------------------------	
	
	function subtract(A : in std_logic_vector (15 downto 0);
							B : in std_logic_vector (15 downto 0))
	return std_logic_vector is
		variable sum : std_logic_vector (15 downto 0);
		variable carry : std_logic_vector (16 downto 0);
	
	begin
	carry(0) := '1';	
		L2 : for i in 0 to 15 loop
			sum(i) := A(i) xor not(B(i)) xor carry(i);
         carry(i+1) := (A(i) and not(B(i))) or (carry(i) and (A(i) or not(B(i))));
      end loop L2 ;
   return carry (16) & sum;
	end subtract;
	
----------------------------------nor--------------------------------------

	function nor_gate(A: in std_logic_vector(15 downto 0))
	return std_logic is
	variable B: std_logic;	

	begin
		B := not(A(15) or A(14) or A(13) or A(12) or A(11) or A(10) or A(9) or A(8) or A(7) or A(6) or A(5) or A(4) or A(3) or A(2) or A(1) or A(0)); 
	return B;
	end nor_gate;

----------------------------------nand--------------------------------------

	function bitwise_nand(A : in std_logic_vector (15 downto 0);
								 B : in std_logic_vector (15 downto 0))
	return std_logic_vector is
		variable C : std_logic_vector (15 downto 0);
	
	begin
		L3 : for i in 0 to 15 loop 
			C(i) := A(i) nand B(i);
		end loop L3;
	return C;
	end bitwise_nand;

-----------------------------------------------------------------------------

signal temp1: std_logic_vector(16 downto 0);
signal temp2: std_logic_vector(15 downto 0);
begin

	process(A,B,op) is
	begin
		if (op = "00") then 
			temp1 <= add(A,B);
			output <= temp1(15 downto 0);
			C <= temp1(16);
			Z <= nor_gate(temp1(15 downto 0));
		elsif (op = "01") then 
			temp1 <= subtract(A,B);
			output <= temp1(15 downto 0);
			C <= temp1(16);
			Z <= nor_gate(temp1(15 downto 0));
		elsif (op = "10") then
			temp2 <= bitwise_nand(A,B);
			output <= temp2;
			C <= '0';
			Z <= nor_gate(temp2);
		else 
			NULL;               ----------------idhar kuch hoga
		end if;
	end process;
			
end Struct; 
