library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg_bank is
	port (D : in std_logic_vector (63 downto 0);
			a1, a2, a3 : in std_logic_vector (4 downto 0);
			Rin, clk : in std_logic;
	      R1, R2: out std_logic_vector (63 downto 0));
end reg_bank;


architecture registers of reg_bank is

component decoder is
	port(in_bits: in std_logic_vector (4 downto 0);
	     out_bits : out std_logic_vector (31 downto 0));
end component;

-- Initialize all registers in bank 
type reg_bank is array (0 to 31) of std_logic_vector (63 downto 0);
signal Reg_File : reg_bank:= (x"0000000000000000",x"0012636f0012636f",x"fff11120fff11120",
										x"0021421000111011",x"0011101121354111",x"ffffffffffffffff",
										x"1111111111111111",x"0021421000214210",x"7844222178442221",
										x"0212acbf0212acbf",x"0017474c0017474c",x"1021254410212544",
										x"1111111011111110",x"1546116515461165",x"1215187712151877",
										x"1235079412350794",x"aaa1bb11aaa1bb11",x"1100110111001101",
										x"1110001111100011",x"3651415436514154",x"2216545522165455",
										x"1325984413259844",x"13774add13774add",x"effa1511effa1511",
										x"254ec111254ec111",x"0000125400001254",x"1120110011201100",
										x"0000ffff0000ffff",x"0000111100001111",x"0000000000005555",
										x"0000000000110011",x"0001111100011111");

signal D_sig : std_logic_vector (63 downto 0):= x"0000000000000000";

begin


	process (Rin, clk, a1, a2, a3, D)
	begin
	
	if clk'event and clk = '0' then
		R1 <= Reg_File(conv_integer (unsigned(a1)));			-- Retrieve register indexed by a1
		R2 <= Reg_File(conv_integer (unsigned(a2)));			-- Retrieve register indexed by a2
		Reg_File(conv_integer (unsigned(a3))) <= D_sig;		-- Store incoming data in register indexed by a3
	end if;
	
	if Rin = '1' and a3 /= "00000" then				--- If write to register bank, don't overwrite to register 0
		D_sig <= D;
	end if;

	end process;
	
end registers;