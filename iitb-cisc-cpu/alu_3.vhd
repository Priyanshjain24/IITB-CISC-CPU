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

	
----------------------------------nor--------------------------------------

	function nor_gate(A: in std_logic_vector(15 downto 0))
	return std_logic is
	variable B: std_logic;	

	begin
		B := not(A(15) or A(14) or A(13) or A(12) or A(11) or A(10) or A(9) or A(8) or A(7) or A(6) or A(5) or A(4) or A(3) or A(2) or A(1) or A(0)); 
	return B;
	end nor_gate;
	
------------------------------------add-------------------------------------	
	
	function add ( A : in std_logic_vector ( 15 downto 0 ) ;
						B : in std_logic_vector ( 15 downto 0 ) )
	return std_logic_vector is
		variable sum : std_logic_vector ( 15 downto 0 ) ;
		variable carry : std_logic_vector ( 15 downto 0 ) ;
	
	begin
		L1 : for i in 0 to 15 loop
				if i = 0 then
                sum(i) := A(i) xor B(i) ;
                carry(i) := A(i) and B(i) ;
            else
                sum(i) := A(i) xor B(i) xor carry(i-1) ;
                carry(i) := ( A(i) and B(i) ) or ( carry(i-1) and ( A(i) or B(i) ) ) ;
                          
            end if ;
        end loop L1 ;
	 return sum;
	 end add;
	 
---------------------------------carry----------------------------------------
	 
	 function lambda ( A : in std_logic_vector ( 15 downto 0 ) ;
						B : in std_logic_vector ( 15 downto 0 ) )
	return std_logic is
		variable sum : std_logic_vector ( 15 downto 0 ) ;
		variable carry : std_logic_vector ( 15 downto 0 ) ;
	
	begin
		L1 : for i in 0 to 15 loop
				if i = 0 then
                sum(i) := A(i) xor B(i) ;
                carry(i) := A(i) and B(i) ;
            else
                sum(i) := A(i) xor B(i) xor carry(i-1) ;
                carry(i) := ( A(i) and B(i) ) or ( carry(i-1) and ( A(i) or B(i) ) ) ;
                          
            end if ;
        end loop L1 ;
	 return carry(15);
	 end lambda;
	 
----------------------------------zero----------------------------------------
	 
	function zero ( A : in std_logic_vector ( 15 downto 0 ) ;
						B : in std_logic_vector ( 15 downto 0 ) )
	return std_logic is
		variable sum : std_logic_vector ( 15 downto 0 ) ;
		variable carry : std_logic_vector ( 15 downto 0 ) ;
	
	begin
		L1 : for i in 0 to 15 loop
				if i = 0 then
                sum(i) := A(i) xor B(i) ;
                carry(i) := A(i) and B(i) ;
            else
                sum(i) := A(i) xor B(i) xor carry(i-1) ;
                carry(i) := ( A(i) and B(i) ) or ( carry(i-1) and ( A(i) or B(i) ) ) ;
                          
            end if ;
        end loop L1 ;
	 return nor_gate(sum);
	 end zero;
	
----------------------------------sub-----------------------------------------	
	
	function subtract(A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0))
		return std_logic_vector is
			-- declaring and initializing variables using aggregates
			variable diff : std_logic_vector(15 downto 0):= (others=>'0');
			variable comp : std_logic_vector(15 downto 0);
			variable negative : std_logic_vector(15 downto 0);
			variable f : std_logic_vector(15 downto 0) := (0=>'1',others=>'0');

		begin
			L1 : for i in 0 to 15 loop
			comp(i) := not(B(i)) ;
			end loop L1;
			
			negative := add(f, comp); 
			diff := add(A, negative) ;
			
			return diff;
	end subtract;
	
---------------------------------alpha----------------------------------------

	function alpha(A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0))
		return std_logic is
			-- declaring and initializing variables using aggregates
			variable comp : std_logic_vector(15 downto 0);
			variable negative : std_logic_vector(15 downto 0);
			variable f : std_logic_vector(15 downto 0) := (0=>'1',others=>'0');

		begin
			L1 : for i in 0 to 15 loop
			comp(i) := not(B(i)) ;
			end loop L1;
			
			negative := add(f, comp); 
			
			return lambda(A,negative);
	end alpha;
	
--------------------------------------zero2---------------------------------

	function zero2(A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0))
		return std_logic is
			-- declaring and initializing variables using aggregates
			variable diff : std_logic_vector(15 downto 0):= (others=>'0');
			variable comp : std_logic_vector(15 downto 0);
			variable negative : std_logic_vector(15 downto 0);
			variable f : std_logic_vector(15 downto 0) := (0=>'1',others=>'0');

		begin
			L1 : for i in 0 to 15 loop
			comp(i) := not(B(i)) ;
			end loop L1;
			
			negative := add(f, comp); 
			diff := add(A, negative(15 downto 0)) ;
			
			return nor_gate(diff);
	end zero2;

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
	
----------------------------------nand_zero---------------------------------

	function nand_zero(A : in std_logic_vector (15 downto 0);
							B : in std_logic_vector (15 downto 0))
	return std_logic is
		variable C : std_logic_vector (15 downto 0);
	
	begin
		L3 : for i in 0 to 15 loop 
			C(i) := A(i) nand B(i);
		end loop L3;
	return nor_gate(C);
	end nand_zero;

-----------------------------------------------------------------------------

begin

	alu: process(A,B,op) is
	begin
		if (op = "00") then 
		 output <= add(A,B);
		 C <= lambda(A,B);
		 Z <= zero(A,B);
		elsif (op = "01") then 
			output <= subtract(A,B);
			 C <= alpha(A,B);
			 Z <= zero2(A,B);
		elsif (op = "10") then
			output <= bitwise_nand(A,B);
			C <= '0';
			Z <= nand_zero(A,B);
		else 
			output <= "0000000000000000";
			C <= '0';
			Z <= '0';
			               ----------------idhar kuch hoga
		end if;
	end process;
			
end Struct; 