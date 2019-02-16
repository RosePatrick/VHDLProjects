library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Execute is
port(IR3 : in std_logic_vector (31 downto 0); 				-- IR copy
		clk : in std_logic;
		X3, Y3, MD3 : in std_logic_vector (63 downto 0);	-- Intermediary registers
		flags : inout std_logic_vector (3 downto 0);			-- C, N, V, Z
		IR4  : out std_logic_vector (31 downto 0);
		Z4, MD4 : out std_logic_vector (63 downto 0));
end Execute;

architecture Behavioral of Execute is

component cpu_alu is
port (A: in std_logic_vector(63 downto 0);
		B: in std_logic_vector (63 downto 0);
		opcode: in std_logic_vector (4 downto 0);
		count: in std_logic_vector (5 downto 0);
		Y: out std_logic_vector (63 downto 0);
		flags: inout std_logic_vector(3 downto 0));
end component;

begin

ALU: cpu_alu port map(
	  A => X3,
	  B => Y3,
	  opcode => IR3(31 downto 27),
	  count => IR3(5 downto 0),
	  Y => Z4,
	  flags => flags);
	  
process (clk)
begin
	if clk'event and clk = '1' then
		MD4 <= MD3;
		IR4 <= IR3;
	end if;
 end process;
end Behavioral;

