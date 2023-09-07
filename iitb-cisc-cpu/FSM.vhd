library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.numeric_std.all; 

entity FSM is
    	port(
		clk, rst, Cin, Zin: in std_logic;
        instruction: in std_logic_vector(15 downto 0);
        A1_out, A2_out, A3_out: out std_logic_vector(2 downto 0); 
        S, AM1, AM2, RFWRS, rf_StorM: out std_logic_vector(1 downto 0);
		  Imm6: out std_logic_vector(5 downto 0);
		  Imm9: out std_logic_vector(8 downto 0);
        -- RFM: out std_logic;

        -- T1, T2: out std_logic_vector(15 downto 0);
        -- wr_rf, wr_alu, wr_mem, wr_T1, wr_T2, wr_T3: out std_logic;
        -- data_in: out std_logic_vector(15 downto 0);
        wr_mem, wr_IR, wr_T1, wr_T2, wr_T3, wr_C, wr_Z, RFexp : out std_logic);

end entity;


architecture controller of FSM is 
constant n : integer := 2;
-------components and signals------------
type FSM_State is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S99, S100, S101);

signal PS: FSM_State := S0;

   signal NxtS: FSM_State;
   signal Op : std_logic_vector(3 downto 0):= instruction(15 downto 12);
   signal A1 : std_logic_vector(2 downto 0):= instruction(11 downto 9);
   signal A2 : std_logic_vector(2 downto 0):= instruction(8 downto 6);
   signal A3 : std_logic_vector(2 downto 0):= instruction(6 downto 4);
   signal Ctemp : std_logic:= instruction(1);
   signal Ztemp : std_logic:= instruction(0);
   signal CZtemp : std_logic_vector(1 downto 0):= instruction(1 downto 0);
   
   signal wr_rfM : std_logic_vector(3 downto 0);
   signal data_null: std_logic_vector(15 downto 0) :=(others => '0');

begin
   
   Imm6 <= instruction(5 downto 0);
   Imm9 <= instruction(8 downto 0);
	
 
 
 -----------------------------------------------------------------------------------
 StateTransProc: process(clk)

 variable Twr_mem, Twr_IR, Twr_T1, Twr_T2, Twr_T3, Twr_C, Twr_Z, TRFexp : std_logic;
 variable TA1_out, TA2_out, TA3_out: std_logic_vector(2 downto 0):= "000"; 
 variable TS, TAM1, TAM2, TRFWRS, Trf_StorM: std_logic_vector(1 downto 0);
variable pc_counter: integer:= 0;
--	TA1_out := "000";
--    TA2_out := "000";
--    TA3_out := "000";
	begin
  
    if (CZtemp = "00" or (CZtemp = "10" and Cin = '1') or (CZtemp = "01" and Zin = '1')) then
		TRFexp := '1';
	else
		TRFexp := '0';
	end if;
	
   Twr_mem :='0';
   Twr_IR :='0';
   Twr_T1 :='0';
   Twr_T2 :='0';
   Twr_T3 :='0';
   Twr_C :='0';
   Twr_Z :='0';
   
    TS := "00";
    TAM1 :="00";
    TAM2 :="00";
    NxtS <=S0;
	 

    case PS is

        when S0 => --Storing PC to IR
        
        pc_counter := pc_counter+1;
        Twr_IR :='1';

        if (Op="0000" or Op="0010") then
        NxtS <= S1;
        elsif (Op="0001" or Op ="0100" or Op="0101" or Op="1100" or Op="1001") then
        NxtS <= S2;
        else
        NxtS <= S3;
        end if;

        when S1 => --Taking Ra and Rb for R Type

        TA1_out := A1;
        TA2_out := A2;
        Twr_T1 := '1';
        Twr_T2 := '1';

        NxtS <= S4;

        when S2 => --Taking Ra for I Type

        TA1_out := A1;
        Twr_T1 := '1';

        if (Op="0001" or Op="0100" or Op="0101" or Op = "1100") then
        NxtS <= S4;
        ---elsif (Op="1001") then
        ---NxtS<= -- Still to Define;
			end if;

        ---STATE 4 ALU
        when S4 => --VERY IMPORTANT STATE

        Twr_T3 := '1';
        if (Op="0000" or Op="0010" or Op="0001") then
        TS :="00";
        TAM1 := "00";
        TAM2 := '0' & Op(0);

        elsif (Op="0100" or Op="0101" or Op = "1100") then
        TS := "00";
        TAM1 := "01";
        TAM2 := "01";
			end if;

        if (Op="0000" or Op="0010" or Op="0001") then
        NxtS <= S5;
			end if;
			
        when S5 =>
		  

			TRFWRS := "10"; --write expression for selectline;
			Trf_StorM := "10"; -- write expression for storage register;
			

        NxtS <= S99;


        when S99 =>
        Twr_T3 :='1';

        TS := "00";
        TAM1 := "01";
        TAM2 := "10";

        NxtS <=S100;
----------------------------------------------
        when S100 =>

  
        TRFWRS :="01";
        Trf_StorM :="11";
		  
		  --if pc_counter = n then 
			--NxtS <= S101;
			--else
			NxtS <=S0;
		--end if;
----------------------------------------------
		 -- when S101 =>
		  
----------------------------------------------
        when others =>
        NxtS <= S0;
end case;
   wr_mem <= Twr_mem;
   wr_IR <= Twr_IR;
   wr_T1 <= Twr_T1;
   wr_T2 <= Twr_T2;
   wr_T3 <= Twr_T3;
   wr_C <= Twr_C;
   wr_Z <= Twr_Z;
   A1_out <= TA1_out ;
   A2_out <= TA2_out ;
    A3_out <= TA3_out ;
    S <= TS;
    AM1 <= TAM1;
    AM2 <= TAM2;
    RFexp <= TRFexp;
    RFWRS<= TRFWRS;
    rf_StorM <= Trf_StorM;

    if(clk = '1' and clk'event) then
    if (rst='1') then
		PS<=S0;
    else
		PS <= NxtS;
    end if;
	 end if;


end process;
end architecture;


        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        -- when S0 =>

        -- wr_IR<='1';

        -- if (Op="0000" or Op ="0010")
        -- NxtS := S1;
        -- elsif (Op="0001" or Op="0100" or Op="0101" or Op="1100" or Op="1001")
        -- NxtS := S2;
        -- elsif (Op="0110" or Op="0111")
        -- NxtS := S3;
        -- elsif(Op="1000")
        -- NxtS := S10;
        -- elsif(Op="0011")
        -- NxtS := S12;


        -- when S1 =>
        -- -- RF : RegisterFile port map(clk, rst, '0', A1, A2, A3, data_in, data1, data2);

        -- -- T1 : reg8 port map(clk, rst, '1', data1, T1_out);

        -- wr_T1 <= '1';
        -- wr_T2 <= '1';

        -- if(Op="0010")
        -- NxtS:= S4;
        -- elsif (Op="0000")
        -- NxtS:= S5;


        -- when S2 =>

        -- wr_T1 <= '1';
        -- wr_T2 <= '1';


        -- if(Op="0001")
        -- NxtS:= S6;
        -- elsif(Op="0100")
        -- NxtS:= S7;
        -- elsif(Op="0101")
        -- NxtS:= S8;
        -- elsif(Op="1100")
        -- NxtS:= S9;
        -- elsif(Op="1001")
        -- NxtS:= S11;



        -- when S3 =>

        -- wr_T1 <='1';
        -- wr_T3 <= '1';

        -- if(Op="0101" or Op="0110")
        -- NxtS:= S13;

        -- when S4 =>

        -- wr_T3<='1';
        -- wr_RF<='1';

        -- if(Op="0010" and ) -- thoda locha h dekhte h lastme
        -- NxtS:= S17;
        -- elsif(Op="")
        -- NxtS:= S19;


        -- when S5 =>

        -- wr_T3<='1';
        -- wr_RF<='1';

        -- if(Op="0101")
        -- NxtS:= S17;
        -- elsif(Op="0101")
        -- NxtS:= S19;


        -- when S6=>

        -- if(Op="0001")
        -- NxtS:= S17;

        -- when S7=>

        -- if(Op="0100")
        -- NxtS:= S17;

        -- when S8=>

        -- if(Op="0101")
        -- NxtS:= S19;

        -- when S9=>

        -- if(Op="1100")
        -- NxtS:= S0;


        -- when S10=>


        -- when S11 =>

        -- NxtS := S0;

        -- when S12 =>

        -- NxtS := S19;

        -- when S13 =>

        -- if(Op="0110")
        -- NxtS:= S14;
        -- elsif(Op="0111")
        -- NxtS:= S15;
        
        -- when S14 =>
        
        -- NxtS := S16;

        -- when S15 =>
        
        -- NxtS := S16;

        -- when S16 =>

        -- if(Z="0")                   -----define karna padega Z variable which we will get from ALU
        -- NxtS:= S13;
        -- elsif(Z="1")
        -- NxtS:= S19;

        -- when S17 =>

        -- if(Op="0000" or "0001")
        -- NxtS:= S18;
        -- elsif(Op="0010" or "0100")
        -- NxtS:= S19;

        -- when S18 =>

        -- NxtS := S19;

        -- when S19 =>

        -- NxtS := S0;








