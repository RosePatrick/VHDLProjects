library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Write_back2 is
port( IR5 : in std_logic_vector (31 downto 0);
		clk : in std_logic;
		Z5 : in std_logic_vector (63 downto 0);
		W3 : out std_logic;
		a3 : out std_logic_vector (4 downto 0);
		R3 : out std_logic_vector (63 downto 0));
end Write_back2;

architecture Behavioral of Write_back2 is
signal opcode : std_logic_vector (4 downto 0);
begin

opcode <= IR5(31 downto 27);

process (opcode, clk)
begin

	if clk'event and clk = '1' then
		R3 <= Z5;
	   a3 <= IR5(26 downto 22);

-- Determine whether contents of Register Z5 need to be stored in the register bank (for Load and ALU operations only)
	case opcode is 
		when "00001" => W3 <= '1';		-- Add
		when "10101" => W3 <= '1';		-- Addi
		when "00010" => W3 <= '1';		-- Sub
		when "10001" => W3 <= '1';		-- Inc
		when "10010" => W3 <= '1';		-- Dec					
-------------------------------------------------------------------------				
		when "01011" => W3 <= '1';		-- AND
		when "10110" => W3 <= '1';		-- ANDI
		when "01100" => W3 <= '1';		-- OR
		when "10111" => W3 <= '1'; 	-- ORI
		when "01101" => W3 <= '1'; 	-- NOT
--------------------------------------------------------------------------			
		when "00101" => W3 <= '1';		-- Arithmetic shift right
		when "00110" => W3 <= '1';		-- Arithmetic shift left
		when "00111" => W3 <= '1';		-- Logical shift right	
		when "01000" => W3 <= '1';		-- Logical shift left			
		when "01001" => W3 <= '1';		-- Rotate right
		when "01010" => W3 <= '1';		-- Rotate left
--------------------------------------------------------------------------
		when "01110" => W3 <= '1'; 	-- Load
		when others => W3 <= '0';
	end case;
	end if;
	
end process;	
end Behavioral;

