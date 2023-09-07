library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.numeric_std.all; 

entity FSMpro is
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


architecture lmao of FSMpro is
    type FSM_State is (S0, S1, S2, S3, S4, S5, S9, S99, S100);
    signal ps_state, nx_state : FSM_State := S0;

   signal Op : std_logic_vector(3 downto 0):= instruction(15 downto 12);
   signal A1 : std_logic_vector(2 downto 0):= instruction(11 downto 9);
   signal A2 : std_logic_vector(2 downto 0):= instruction(8 downto 6);
   signal A3 : std_logic_vector(2 downto 0):= instruction(6 downto 4);
   signal Ctemp : std_logic:= instruction(1);
   signal Ztemp : std_logic:= instruction(0);
   signal CZtemp : std_logic_vector(1 downto 0):= instruction(1 downto 0);

   

    begin

        transition_process: process(clk,rst)

        begin
        if(rst='1')then 
        ps_state<=S0;
        elsif(clk'event and clk='1')then
        ps_state<=nx_state;
        end if;
        end process transition_process;



        next_state_logic: process (ps_state)

        begin
            case ps_state is


                when S0 =>
                nx_state <= S1;

                when S1 =>
                nx_state <= S4;

                when S4 =>
                nx_state <= S5;

                when S5 =>
                nx_state <= S99;

                when S99 =>
                nx_state <= S100;

                when S100 =>
                nx_state <= S0;

                when others =>
                null;


        end case;
        end process;

        Output_process: process(ps_state)

        begin

          if (CZtemp = "00" or (CZtemp = "10" and Cin = '1') or (CZtemp = "01" and Zin = '1')) then
		    RFexp <= '1';
	        else
	    	 RFexp <= '0';
	        end if;

            wr_mem <='0';
            wr_IR <='0';
            wr_T1 <='0';
            wr_T2 <='0';
            wr_T3 <='0';
            wr_C <='0';
            wr_Z <='0';
            
            S <= "00";
            AM1 <="00";
            AM2 <="00";
        

            case ps_state is

                when S0 =>

                wr_IR<='1';

---------------------------------------------
                when S1 =>

                A1_out <= A1;
                A2_out <= A2;
                wr_T1 <= '1';
                wr_T2 <= '1';

-----------------------------------------------
                when S4 =>

                wr_T3 <= '1';
                S <= "00";

                if (Op="0000" or Op="0010" or Op="0001") then
                AM1 <= "00";
                AM2 <= '0' & Op(0);

                elsif(Op="0100" or Op="0101" or Op = "1100") then
                AM1 <= "01";
                AM2 <= "01";

                end if;
--------------------------------------------
                when S5 =>
                
                if (Op="0001") then
                RFWRS <="01";
                rf_StorM <= "10";
                elsif (Op="0000") then
                RFWRS <= "10";
                rf_StorM <= "01";
                end if;

---------------------------------------------
                when S99 =>

                wr_T3 <= '1';
                S <="00";
                AM1 <= "01";
                AM2 <= "10";
-------------------------------------------
                when S100 =>

                RFWRS <= "01";
                rf_StorM <= "11";
-------------------------------------------
					when others =>
					null;
					
        end case;
        end process;

end architecture; 


