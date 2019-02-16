library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Fetch1 is
port (MemDone, clk, reset, start : in std_logic;
		Mem_inst : in std_logic_vector (31 downto 0);
		Memread, enable : out std_logic;
		IR_main : out std_logic_vector(31 downto 0); --, IR_br
		Mem_addr, PC_main : out std_logic_vector(63 downto 0)); --, PC_br
end Fetch1;

architecture Behavioral of Fetch1 is

component PC_mem is
port (clk, Done_s, Start, reset  : in std_logic;							--- clock, external memory read & done, Start and reset signals
		Read_s: out std_logic;
		IRin: in std_logic_vector (31 downto 0);							--- Receives instruction from memory
		IRout: out std_logic_vector (31 downto 0);							--- IR output, 
		Addr2mem, PCout: out std_logic_vector (63 downto 0));   			--- Memory data bus, PC output
end component;

signal opcode : std_logic_vector (4 downto 0);
signal IRcopy : std_logic_vector (31 downto 0);
signal PCcopy : std_logic_vector (63 downto 0);  --, PC
signal en : std_logic := '0';

begin


PC1: PC_mem port map(
	  clk => clk,
	  Done_s => MemDone,
	  Start => start,
	  reset => reset,
	  Read_s => Memread,
	  IRin => Mem_inst,
	  IRout => IRcopy,
	  Addr2mem => Mem_addr,
	  PCout => PCcopy);

	opcode <= IRcopy(31 downto 27);
	enable <= en;

process (opcode, IRcopy, PCcopy)
begin
--	if opcode = "10011" or opcode = "10100" then
--		IR_br <= IRcopy;
--		PC_br <= PCcopy;
--		en <= '1';
--	else
		IR_main <= IRcopy;
		PC_main <= PCcopy;
--	end if;
	
--	if opcode = "11101" then
--		en <= '0';
--	end if;


end process;
end Behavioral;

