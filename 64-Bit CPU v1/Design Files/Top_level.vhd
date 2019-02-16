library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_level is
port (MemDone, clk, reset, start, Done, interrupt: in std_logic;
		Mem_inst : in std_logic_vector (31 downto 0);
		Memread, RD, WR : out std_logic; --, RDb, WRb
		flags : inout std_logic_vector (3 downto 0);
		run, ireq : out std_logic;
		--IR_br : out std_logic_vector (31 downto 0);
		Mbus : inout  std_logic_vector(63 downto 0); --, Mbus1
		Mem_addr1, Mem_addr2 : out std_logic_vector(63 downto 0)); --, PC_br, Mem_addr3
end Top_level;

architecture Behavioral of Top_level is

--component top_level_br is
--port (clk, Done: in std_logic;          ---, run
--		IR_br: in std_logic_vector (31 downto 0);
--		RD_b, WR_b : out std_logic;
--		flags : inout std_logic_vector (3 downto 0);
--		Mbus_b : inout  std_logic_vector(63 downto 0);
--		PC_br : in std_logic_vector(63 downto 0);
--		Mem_addr3 : out std_logic_vector(63 downto 0));
--end component;

component Fetch1 is
port (MemDone, clk, reset, start : in std_logic;
		Mem_inst : in std_logic_vector (31 downto 0);
		Memread, enable : out std_logic;
		IR_main : out std_logic_vector(31 downto 0); -- , IR_br
		Mem_addr, PC_main : out std_logic_vector(63 downto 0)); -- , PC_br
end component;

component Decode is
port (clk : in std_logic;
		R1, R2 : in std_logic_vector (63 downto 0); 			-- Registers output to pipeline
		IR_main : in std_logic_vector (31 downto 0); 			-- IR for main and branch pipelines
		a1, a2 : out std_logic_vector (4 downto 0);				-- Register select
		IR3 : out std_logic_vector (31 downto 0); 				-- IR copy
		X3, Y3, MD3 : out std_logic_vector (63 downto 0));		-- Intermediary registers
end component;

component Execute is
port(IR3 : in std_logic_vector (31 downto 0); 				-- IR copy
		clk : in std_logic;
		X3, Y3, MD3 : in std_logic_vector (63 downto 0);	-- Intermediary registers
		flags : inout std_logic_vector (3 downto 0);			-- Flags as set by ALU
		IR4  : out std_logic_vector (31 downto 0);			-- IR copy
		Z4, MD4 : out std_logic_vector (63 downto 0));
end component;

component Write_Back is
port( Z4, MD4 : in std_logic_vector (63 downto 0);
		IR4 : in std_logic_vector (31 downto 0);
		RD, WR : out std_logic;
		Done, clk : in std_logic;
		Mbus: inout std_logic_vector (63 downto 0);
		IR5 : out std_logic_vector (31 downto 0);
		Z5 : out std_logic_vector (63 downto 0);
		Addrout : out std_logic_vector (63 downto 0));
end component;

component Write_back2 is
port( IR5 : in std_logic_vector (31 downto 0);
		clk : in std_logic;
		Z5 : in std_logic_vector (63 downto 0);
		W3 : out std_logic;
		a3 : out std_logic_vector (4 downto 0);
		R3 : out std_logic_vector (63 downto 0));
end component;

component reg_bank is
	port (D : in std_logic_vector (63 downto 0);
	      a1, a2, a3 : in std_logic_vector (4 downto 0);
		  Rin, clk : in std_logic;
	      R1, R2: out std_logic_vector (63 downto 0));
end component;

--signal declarations
signal PCm, PC_sig, Z4_s, X3_s, Y3_s,  MD3_s, MD4_s  : std_logic_vector (63 downto 0); --PCb,
signal to_R1, to_R2, to_R3, Z5_s : std_logic_vector (63 downto 0);
signal IRm, IR4_s, IR3_s, IR5_s: std_logic_vector (31 downto 0); -- IRb, 
signal a1_s, a2_s, a3_s  : std_logic_vector (4 downto 0);
signal flag_s : std_logic_vector (3 downto 0);
signal Rin_s: std_logic;
signal run_s : std_logic := '0';

begin 


--- Connecting all stages together to form one context pipeline
FE: Fetch1 port map (
		MemDone => MemDone, 
		clk => clk, 
		reset => reset, 
		start => start,
		Mem_inst => Mem_inst,
		Memread => Memread,
		IR_main => IRm, 
		--IR_br => IRb,
		Mem_addr => Mem_addr1, 
		PC_main => PCm);
		--PC_br => PCb);


--PC_br <= PCb;
--IR_br <= IRb;

--BR:   top_level_br port map(
--		clk => clk,
--		Done => Done,
--		--run => run_s,
--		IR_br => IRb,
--		RD_b => RDb,
--		WR_b => WRb,
--		flags => flag_s,
--		Mbus_b => Mbus1,
--		PC_br => PCb,
--		Mem_addr3 => Mem_addr3);
		
DE:   Decode port map (
		clk => clk, 
		R1 => to_R1, 
		R2 => to_R2,
		IR_main => IRm,
		a1 => a1_s, 
		a2 => a2_s,
		IR3 => IR3_s,
		X3 => X3_s, 
		Y3 => Y3_s, 
		MD3 => MD3_s);	
		
REG:	reg_bank port map(
		D => to_R3,
		a1 => a1_s, 
		a2 => a2_s, 
		a3 => a3_s,
		Rin => Rin_s, 
		clk => clk,
	   R1 => to_R1, 
		R2 => to_R2);
		
EX:	Execute port map(
		IR3 => IR3_s,
		clk => clk,
		X3 => X3_s, 
		Y3 => Y3_s, 
		MD3 => MD3_s,
		flags => flags,
		IR4 => IR4_s,
		Z4 => Z4_s, 
		MD4 => MD4_s);

MA:	Write_back port map(
		Z4 => Z4_s, 
		MD4 => MD4_s,
		IR4 => IR4_s,
		RD => RD, 
		WR => WR,
		Done => Done, 
		clk => clk,
		Mbus => Mbus,
		IR5 => IR5_s,
		Z5 => Z5_s, 
		Addrout => Mem_addr2);
		
WB:	Write_back2 port map(
		IR5 => IR5_s,
		clk => clk,
		Z5 => Z5_s,
		W3 => Rin_s, 
		a3 => a3_s,
		R3 => to_R3);



---------------------------GENERAL SYSTEM----------------------------------------------------		
run <= run_s;
process (start, run_s, reset, interrupt)						-- Managing Start, Run and Reset signals to processor
begin

	if run_s = '0' and start = '1' then
		run_s <= '1';
		PC_sig <= x"0000000000000000";
	elsif run_s = '1' and reset = '1' then
		PC_sig <= x"0000000000000000";
		run_s <= '0';
	end if;
	if run_s = '1' and interrupt = '1' then
		ireq <= '1';
	end if;
	end process;	
end Behavioral;

