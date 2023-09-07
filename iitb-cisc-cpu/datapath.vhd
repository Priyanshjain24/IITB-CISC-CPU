library std;
library ieee;
use ieee.std_logic_1164.all;

entity Datapath is
port(mem_in: in std_logic_vector(15 downto 0);
mem_out: out std_logic_vector(15 downto 0);
clk_out: out std_logic
);
--, rf_in: in std_logic_vector(15 downto 0);
--     A1, A2, A3, Imm6, Imm9: in std_logic_vector(2 downto 0);
--  clk, rst, wr_mem, wr_IR, wr_RF, wr_T1, wr_T2, wr_T3, wr_C, wr_Z : in std_logic;
--  instruction, C, Z : out std_logic;
--  );
end entity;


architecture path of Datapath is

component Memory is
port (clk, wr: in std_logic;
    A: in std_logic_vector(15 downto 0);
	Din: in std_logic_vector(15 downto 0);
    Dout: out std_logic_vector(15 downto 0));
end component;

component RegisterFile is
port(
    clk, rst, wr: in std_logic;
    A1,A2,A3: in std_logic_vector(2 downto 0); --maybe 3 addresses are not needed
	Din: in std_logic_vector(15 downto 0);
    Dout1, Dout2, pc, r: out std_logic_vector(15 downto 0));
end component;

component reg_16 is
port(
  clk, rst, wr: in std_logic;
  Din: in std_logic_vector(15 downto 0);
  Dout: out std_logic_vector(15 downto 0));
end component;

component reg_1 is
port(
  clk, rst, wr: in std_logic;
  Din: in std_logic;
  Dout: out std_logic);
end component;


component alu is
port(
		A,B: in std_logic_vector(15 downto 0);
		op: in std_logic_vector(1 downto 0);
		output: out std_logic_vector(15 downto 0);
		C,Z: out std_logic) ;
end component;


component  nine_extender is
  port (A: in std_logic_vector(8 downto 0); B: out std_logic_vector(15 downto 0));
end component;

component six_extender is
  port (A: in std_logic_vector(5 downto 0); B: out std_logic_vector(15 downto 0));
end component;

component Mux16_4_1 is
port( A, B, C, D : in std_logic_vector(15 downto 0);
		S: in std_logic_vector(1 downto 0);
		y : out std_logic_vector(15 downto 0) );
end component;

component Mux16_2_1 is
port( A, B : in std_logic_vector(15 downto 0);
		S: in std_logic;
		y : out std_logic_vector(15 downto 0) );
end component;

component Mux3_8_1 is
port( A, B, C, D, E, F, G, H : in std_logic_vector(2 downto 0);
		S : in std_logic_vector(2 downto 0);
		y : out std_logic_vector(2 downto 0) );
end component;

component mux_four_to_one is
	port(A,B,C,D : in std_logic; 
	S : in std_logic_vector(1 downto 0);
	Z: out std_logic);
end component;

component clock_generator is
port (clk_out, rst : out std_logic);
end component;

component shifter is
	port (A: in std_logic_vector(8 downto 0); B: out std_logic_vector(15 downto 0));
end component;

component FSMultraProMax is
    	port(
		clk, rst, Cin, Zin, v: in std_logic;
        instruction, T1, T2: in std_logic_vector(15 downto 0);
--        A1_out, A2_out, A3_out: out std_logic_vector(2 downto 0); 
        S, AM1, AM2, RFWRS, temp, T5M: out std_logic_vector(1 downto 0);
		  rf_StorM: out std_logic_vector(2 downto 0);
--		  Imm6: out std_logic_vector(5 downto 0);
--		  Imm9: out std_logic_vector(8 downto 0);
        -- RFM: out std_logic;

        -- T1, T2: out std_logic_vector(15 downto 0);
        -- wr_rf, wr_alu, wr_mem, wr_T1, wr_T2, wr_T3: out std_logic;
        -- data_in: out std_logic_vector(15 downto 0);
        wr_mem, wr_IR, wr_T1, wr_T2, wr_T3, wr_T4, wr_T5, wr_T6, wr_C, wr_Z, RFexp, T3M, MADS, RFDS, EXS, T1MS, RFOS, MDS: out std_logic;
		  State_value: out std_logic_vector(3 downto 0));


end component;

component Penc_8_3 is
port (
clk: in std_logic;
input: in std_logic_vector(15 downto 0);
bin: out std_logic_vector(2 downto 0);
output: out std_logic_vector(15 downto 0);
v : out std_logic:= '0'
);
end component;

component Mux3_2_1 is
port( A, B: in std_logic_vector(2 downto 0);
		S : in std_logic;
		y : out std_logic_vector(2 downto 0) );
end component;

signal rf_in, instruction: std_logic_vector(15 downto 0);
signal clk, rst, wr_mem, wr_IR, wr_T1, wr_T2, wr_T3, wr_T4, wr_T5, wr_T6, wr_C, wr_Z : std_logic;
signal C, Z, RFexp : std_logic;
signal wr_RF: std_logic:= '0';

signal ir_mem, pc, r,
  rf_t3, rf_t1, rf_t2, rf_t4, t1_in, t5_in, t6_t5,
  m1_t1, m2_t2, m3_t3,
  m1_alu, m2_alu, m3_alu,
  m3_shift, mem_address, RFDin,
  penc_t5, penc_mux, MemDin,
  ext, ext6, ext9, T1, T2: std_logic_vector(15 downto 0);

signal m1_clu, m2_clu, alu_clu, RFWRS, temp, T5M: std_logic_vector(1 downto 0);
signal A1,A2,A3,A4, A3_store, A2_read, rf_StorM: std_logic_vector(2 downto 0);
signal c_alu, z_alu, c_clu, z_clu, m3_clu, MADS, RFDS, EXS, T1MS, RFOS, MDS, v: std_logic;
signal Imm6: std_logic_vector(5 downto 0);
signal Imm9: std_logic_vector(8 downto 0);
signal counter: integer;
signal state_value: std_logic_vector (3 downto 0);
--signal A1, A2, A3: std_logic_vector (2 downto 0);
begin

A1<= instruction(11 downto 9);
A2<= instruction(8 downto 6);
A3<= instruction(5 downto 3);
Imm6<= instruction(5 downto 0);
Imm9<= instruction(8 downto 0);

Controller: FSMultraProMax port map(clk, rst, C, Z, v, instruction, T1, T2,
                    alu_clu, m1_clu, m2_clu, RFWRS, temp, T5M, rf_StorM, 
						  wr_mem, wr_IR, wr_T1, wr_T2, wr_T3, wr_T4, wr_T5, wr_T6, wr_C, wr_Z, RFexp, m3_clu, MADS, RFDS, EXS, T1MS, RFOS, MDS, state_value);

-----------------------------------
mem_mux_address : Mux16_2_1 port map(pc, rf_t3, MADS, mem_address);
Memin_mux : Mux16_2_1 port map(m1_t1,m2_t2, MDS, MemDin);
mem : Memory port map(clk, wr_mem, mem_address, MemDin, ir_mem);
-----------------------------------
--mem_out <= "000000000000000"&rst;
mem_out <=instruction;
-----------------------------------
IR : reg_16 port map(clk, rst, wr_IR, ir_mem, instruction);
-------------------------------------------------------------------------
Reg_File_Mux_for_storageReg: Mux3_8_1 port map(A1, A2, A3,"111",A4,"000","000","000",rf_StorM,A3_store);
RFMux_for_writeEnable: mux_four_to_one port map('0','1',RFexp,'1',RFWRS,wr_RF);
RFDin_mux : Mux16_2_1 port map(rf_t3, rf_t4, RFDS, RFDin);


RFDout_mux : Mux3_2_1 port map(A2, A4, RFOS, A2_read); -- for SM
RF : RegisterFile port map(clk, rst, wr_RF, A1, A2_read, A3_store, RFDin, rf_t1, rf_t2, pc,r);
-------------------------------------------------------------------------
rf_t1_mux : Mux16_2_1 port map(rf_t1, rf_t3, T1MS, t1_in);
penc_t5_mux : Mux16_4_1 port map(penc_t5, ext9, t6_t5, "0000000000000000",T5M, t5_in);

-- Make Memory Address MUX to choose from PC and T3
T_1 : reg_16 port map(clk, rst, wr_T1, t1_in, m1_t1);
T_2 : reg_16 port map(clk, rst, wr_T2, rf_t2, m2_t2);
T_3 : reg_16 port map(clk, rst, wr_T3, m3_t3, rf_t3);
T_4 : reg_16 port map(clk, rst, wr_T4, ir_mem, rf_t4);
T_5 : reg_16 port map(clk, rst, wr_T5, t5_in, penc_t5);
T_6 : reg_16 port map(clk, rst, wr_T6, penc_mux, t6_t5);


penc: Penc_8_3 port map(clk,penc_t5,A4,penc_mux,v);

C_flag : reg_1 port map(clk, rst, wr_C, c_alu, C);
Z_flag : reg_1 port map(clk, rst, wr_Z, z_alu, Z);

m_1 : Mux16_4_1 port map(m1_t1, pc, ext, "0000000000000000", m1_clu, m1_alu); --mux going into alu1
m_2 : Mux16_4_1 port map(m2_t2, ext, "0000000000000001","0000000000000000", m2_clu, m2_alu); --mux going into alu2
m_3 : Mux16_2_1 port map(m3_alu, m3_shift, m3_clu, m3_t3); -- mux going into t3 input


T1 <= m1_t1;
T2 <= m2_t2;
---------------------------------------------------------
ext1: six_extender port map(Imm6, ext6);
ext2: nine_extender port map(Imm9, ext9);
ext_mux : Mux16_2_1 port map(ext6, ext9, EXS, ext);
---------------------------------------------------------
shif : shifter port map(Imm9, m3_shift);

ArithLU: alu port map(m1_alu, m2_alu, alu_clu, m3_alu, c_alu, z_alu);
--ArithLU: alu port map(pc, "0000000000000001", "00", m3_alu, c_alu, z_alu);
clock: clock_generator port map(clk,rst);

clk_out <= clk;

-- CLU : controller port map(c_clu, z_clu, wr_mem, wr_IR, wr_RF, wr_T1, wr_T2, wr_T3, wr_C, wr_Z);

end architecture;
