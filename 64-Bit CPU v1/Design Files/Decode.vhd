library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decode is
port (clk : in std_logic;
		R1, R2 : in std_logic_vector (63 downto 0); 				-- Registers output to pipeline
		IR_main : in std_logic_vector (31 downto 0); 			-- IR for main and branch pipelines
		a1, a2 : out std_logic_vector (4 downto 0);				-- Register select
		IR3 : out std_logic_vector (31 downto 0); 				-- IR copy
		X3, Y3, MD3 : out std_logic_vector (63 downto 0));		-- Intermediary registers
end Decode;

architecture Behavioral of Decode is

component instr_reg is
	port (D : in std_logic_vector (31 downto 0);
	      CLK, C1out, C2out: in std_logic;
			opcode: out std_logic_vector (4 downto 0);
	      Q : out std_logic_vector (31 downto 0);
			c1_out, c2_out: out std_logic_vector (63 downto 0));
end component;

component multiplexer is
port (Inp0, Inp1, Inp2: in std_logic_vector (63 downto 0);
		sel : in std_logic_vector (1 downto 0);
		Outp : out std_logic_vector (63 downto 0));
end component;

component  mux_sm is
port ( In1, In2: in std_logic_vector (4 downto 0);
		sel : in std_logic;
		Outp : out std_logic_vector (4 downto 0));
end component;

signal mp2_sel, c1, c2 : std_logic;
signal mp4_sel : std_logic_vector(1 downto 0) := (others => '0');
signal shf_cnt, opcode_sig : std_logic_vector(4 downto 0);
signal ir_sig1: std_logic_vector(31 downto 0);
signal c1out_s, c2out_s  : std_logic_vector(63 downto 0);

begin

IR2:  instr_reg port map(		-- IR for decode stage; all components are available from this IR
		D => IR_main,
		CLK => clk,
		C1out => c1,
		C2out => c2,
		opcode => opcode_sig,
		c1_out => c1out_s,
		c2_out => c2out_s,
		Q => ir_sig1 );

MP2 : mux_sm port map(
		In1 => ir_sig1(16 downto 12),		--- Register R[rc]
		In2 => ir_sig1(26 downto 22),		--- Register R[ra]
		sel => mp2_sel,						--- If instruction is store, select Ra, else select Rc
		Outp => a2);
		
MP4 : multiplexer port map(
		Inp0 => c1out_s,						--- c1 ==> If the instruction involves relative addressing
		Inp1 => c2out_s,						--- c2 ==> If the instruction is ld, st, addi, ori, or andi / if shift count in bits 5-0 is not equal to 0
		Inp2 => R2,								--- Reg value ==> If the instruction is a non-immediate ALU instruction or if shift count in bits 5-0 is equal 0
		sel => mp4_sel,
		Outp => Y3);
		
a1 <= ir_sig1(21 downto 17);				--- Retrieve register from bank
IR3 <= ir_sig1;								--- Copy intermediary register
MD3 <= R2;										--- Retrieve register from bank
X3 <= R1;										--- Retrieve register from bank
 
	
process (clk, opcode_sig)
begin

	if clk'event and clk = '1' then
		if opcode_sig = "01111" then			
			mp2_sel <= '1';					--- If instruction is store, select Ra, else select Rc
		else 
			mp2_sel <= '0';
		end if;
		
-- Depending on the instruction in the pipeline, select c1, c2 or register value
		if opcode_sig = "10110" or 	-- ANDI
		   opcode_sig = "10101" or		-- Addi
			opcode_sig = "10111" or		-- ORI
			opcode_sig = "01110" or		-- Load
			opcode_sig = "01111" then	-- Store
			mp4_sel <= "01"; c2 <= '1';				--choose C2
		end if;
		
		if opcode_sig = "00101" or		-- Arithmetic shift right
			opcode_sig = "00110" or		-- Arithmetic shift left
			opcode_sig = "00111" or		-- Logical shift right	
			opcode_sig = "01000" or		-- Logical shift left			
			opcode_sig = "01001" or		-- Rotate right
			opcode_sig = "01010" then	-- Rotate left
			if shf_cnt /= "00000" then
				mp4_sel <= "01"; c2 <= '1';			--choose C2
			elsif shf_cnt = "00000" then
				mp4_sel <= "10";			
			end if;
		end if;


		if opcode_sig = "00001" or		-- Add
			opcode_sig = "00010" or		-- Sub
			opcode_sig = "10001" or		-- Inc
			opcode_sig = "10010" or		-- Dec									
			opcode_sig = "01011" or		-- AND
			opcode_sig = "01100" or		-- OR
			opcode_sig = "01101" then	-- NOT
				mp4_sel <= "10";	 					-- Choose register R2
		end if;
			
	end if;
end process;			
end Behavioral;

