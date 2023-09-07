library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.numeric_std.all; 

entity FSMultraProMax is
    	port(
		clk, rst, Cin, Zin, v: in std_logic;
        instruction, T1, T2: in std_logic_vector(15 downto 0);
--        A1_out, A2_out, A3_out: out std_logic_vector(2 downto 0); 
        S, AM1, AM2, RFWRS, temp,  T5M: out std_logic_vector(1 downto 0);
		  rf_StorM: out std_logic_vector(2 downto 0);
--		  Imm6: out std_logic_vector(5 downto 0);
--		  Imm9: out std_logic_vector(8 downto 0);
        -- RFM: out std_logic;

        -- T1, T2: out std_logic_vector(15 downto 0);
        -- wr_rf, wr_alu, wr_mem, wr_T1, wr_T2, wr_T3: out std_logic;
        -- data_in: out std_logic_vector(15 downto 0);
        wr_mem, wr_IR, wr_T1, wr_T2, wr_T3, wr_T4, wr_T5, wr_T6, wr_C, wr_Z, RFexp, T3M, MADS, RFDS, EXS, T1MS, RFOS, MDS: out std_logic;
		  State_value: out std_logic_vector(3 downto 0));

end entity;


architecture fsm of FSMultraProMax is
    type FSM_State is ( S0, S1, S2, S3, S4, S5, S6, SL, Sw, S7, S8, S9, S10, S99, S100);
    signal ps_state: FSM_State;
	 signal nx_state : FSM_State;

   signal Op : std_logic_vector(3 downto 0);
--   signal A1 : std_logic_vector(2 downto 0):= instruction(11 downto 9);
--   signal A2 : std_logic_vector(2 downto 0):= instruction(8 downto 6);
-- signal A3 : std_logic_vector(2 downto 0):= instruction(6 downto 4);
   signal Ctemp, Ztemp : std_logic;
   signal C, Z : std_logic:= '0';
   signal CZtemp : std_logic_vector(1 downto 0);



    begin
			Op <= instruction(15 downto 12);
        transition_process: process(clk,rst)

        begin
        if(rst='1')then 
        ps_state<=S0;
        else
		  if(clk'event and clk='0')then
        ps_state<=nx_state;
		  end if;
        end if;
        end process transition_process;



        next_state_logic: process (ps_state)

        begin
            case ps_state is

                when S0 =>
                nx_state <= S1;

                when S1 =>
					 
                if(Op="0011") then
                    nx_state <= S6;
                else
                nx_state <= S4;
                end if;

                when S4 =>
					 
					 if (Op="1100") then
					 if (T1 = T2) then
					 nx_state <= S100;
					 else
					 nx_state <= S99;
					 end if;
					 
					 elsif (Op="0100") then
					 nx_state <= SL;
					 elsif (Op="0101") then
					 nx_state <=SW;
					 elsif (Op="0110") or (Op="0111") then
					 nx_state <= S9;
					 else
                nx_state <= S5;
					 end if;

                when S5 =>      ----saving T3 to Reg File
					 if(Op="1000" or Op="1001") then
					 nx_state <= S8;
					 else
                nx_state <= S99;
					 end if;

                when S6 =>
                nx_state <= S5;
					 
					 when S7 =>
					 nx_state <= S99;
					 
					 when S8 =>
					 nx_state <= S100;
					 
					 when SL =>
					 nx_state <= S7;
					 
					 when SW =>
					 nx_state <= S99;
					 
					 when S9 =>
					 if (v='1') then
					 nx_state <= S99;
					 else 
					 nx_state<=S10;
					 end if;
					 
					 when S10 =>
					 
					 nx_state <= S9;
					

                when S99 =>
                nx_state <= S100;

                when S100 =>
                nx_state <= S0;

                when others =>
                null;


        end case;
        end process next_state_logic;

        Output_process: process(ps_state)

        begin
				temp <= CZtemp;

            if (CZtemp = "00" or (CZtemp = "10" and C = '1') or (CZtemp = "01" and Z = '1')) then
		    RFexp <= '1';
	        else
	    	RFexp <= '0';
	        end if;

            wr_mem <='0';
            wr_IR <='0';
            wr_T1 <='0';
            wr_T2 <='0';
            wr_T3 <='0';
				wr_T4 <= '0';
				wr_T5 <= '0';
				wr_T6 <= '0';
            wr_C <='0';
            wr_Z <='0';
            T3M <= '0';
				MADS <= '0';
				RFDS <= '0';
				EXS <= '0';
				T1MS <= '0';
				RFOS <= '0';
				MDS <= '0';
				T5M <= "00";
				
            S <= "00";
            AM1 <="00";
            AM2 <="00";
				RFWRS <= "00";
				rf_StorM <= "000";
				
				
				Ctemp <= instruction(1);
				Ztemp <= instruction(0);
				CZtemp <= instruction(1 downto 0);
--				A1_out <= instruction(11 downto 9);
--            A2_out <= instruction(8 downto 6);
--				A3_out <= instruction(5 downto 3);
            case ps_state is

                when S0 =>   
					 state_value <="0000";
                wr_IR<='1';
					 RFWRS <="00";

---------------------------------------------
                when S1 =>    
					 state_value <="0001";

					 
                T5M <="01";
					 wr_T5 <= '1';
                wr_T1 <= '1';
                wr_T2 <= '1';
					 
					 

-----------------------------------------------
                when S4 =>     
					 state_value <="0100";
					
					-- C and Z flag modification logic
						if (Op="0000" or Op="0001") then
						wr_C <= '1';
						wr_Z <= '1';
						elsif (Op="0010" or Op="0100") then
						wr_Z<= '1';
						end if;
						
                wr_T3 <= '1';
                T3M <= '0';
               
						
                if (Op="0000" or Op="0010" or Op="0001") then
                if(Op="0010") then
                S <= "10";
                else
                S <= "00";
                end if;
                
                AM1 <= "00";
                AM2 <= '0' & Op(0);

                elsif(Op="0100" or Op="0101") then
					 S <= "00";
                AM1 <= "10";
                AM2 <= "00";
					 
					 elsif (Op="1100") then 
					 S<="00";
					 AM1 <= "01";
					 AM2 <= "01";
					 
					 elsif (Op ="1000" or Op = "1001") then
					 S <= "00";
					 AM1 <= "01";
					 AM2 <= "11";
					 
					 elsif (Op="0110" or Op = "0111") then
					 S <= "00";
					 AM1 <= "00";
					 AM2 <= "11";
					 
                end if;
--------------------------------------------
                when S5 =>     
					 state_value <="0101";
                
                if (Op="0001") then
                RFWRS <="01";
                rf_StorM <= "001";
                elsif (Op="0000" or Op="0010") then
                RFWRS <= "10";
                rf_StorM <= "010";
                elsif (Op="0011" or Op="1000" or Op="1001") then
                RFWRS <= "01";
                rf_StorM <="000";

                end if;
---------------------------------------------
                when S6 =>    
					 state_value <="0110";

                T3M <= '1';
                wr_T3 <= '1';
					 
---------------------------------------------
					when SL =>
					MADS <= '1';
					wr_T4 <= '1';
					
---------------------------------------------
					when S7 =>
					RFWRS <= "01";
					rf_StorM <= "000";
					RFDS <= '1';
					
---------------------------------------------
					when SW =>
					MADS <= '1';
					wr_mem <= '1';
---------------------------------------------
					when S8 =>
					
					wr_T3 <= '1';
                T3M <= '0';
					
					if (Op = "1000") then
					S<="00";
					AM1<="01";
					AM2<="01";
					EXS <= '1';
					
					elsif (Op = "1001") then
					S<="00";
					AM1 <= "11";
					AM2 <= "00";
					end if;
---------------------------------------------
					when S9 =>
					state_value <="1001";
					-- Mem(at T3) to T4
					MADS <= '1';
					wr_T4 <= '1';
					
					-- T3 to T1
					T1MS <= '1';
					wr_T1 <= '1';
					
					
					wr_T6 <= '1';
					
					-- A4 to RF for SM
					RFOS <= '1';
					wr_T2 <= '1';
---------------------------------------------		
					when S10 =>
					state_value <="1010";
					
					-- T1 + 1 to T3
					S<="00";
					AM1<="00";
					AM2<="10";
					wr_T3 <= '1';
					
				
					-- Update T5
					wr_T5<='1';
					T5M <= "10";
					
					if (Op = "0110") then
					-- T4 to RF
					RFDS <= '1'; 
					RFWRS<="01";
					rf_StorM<="100";
					
					else
					MADS <= '1';
					MDS <= '1';
					wr_mem <= '1';
					
					end if;
---------------------------------------------
                when S99 =>     
					 state_value <="1110";

                wr_T3 <= '1';
                S <="00";
                AM1 <= "01";
                AM2 <= "10";
-------------------------------------------
                when S100 =>     
					 state_value <="1111";

                RFWRS <= "01";
                rf_StorM <= "011";
					 
					 C <= Cin;
					 Z <= Zin;
-------------------------------------------
						when others =>
						null;
					
        end case;
        end process Output_process;

end architecture; 


