library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instr_reg is
	port (D : in std_logic_vector (31 downto 0);
	      CLK, C1out, C2out: in std_logic;
			opcode: out std_logic_vector (4 downto 0);
	      Q : out std_logic_vector (31 downto 0);
			c1_out, c2_out: out std_logic_vector (63 downto 0));
end instr_reg;

architecture Behavioral of instr_reg is

component simple32reg is
	port(D : in std_logic_vector (31 downto 0);
	     Q : out std_logic_vector (31 downto 0);
	     clk: in std_logic);
end component;
signal D_sig : std_logic_vector (31 downto 0):= x"00000000";


begin

ir_reg : simple32reg port map (
			D => D_sig,
			clk => CLK,
			Q => Q);
			
--	c1_out <= X"0000000000000000";
--	c2_out <= X"0000000000000000";	
	opcode <= D(31 downto 27);	
	D_sig <= D;
	
process (C1out, C2out, D)
	begin
	
	if C1out = '1' then
		if D(21) = '1' then
			c1_out <= "111111111111111111111111111111111111111111" & D(21 downto 0);
			elsif D(21) = '0' then
				c1_out <= "000000000000000000000000000000000000000000" & D(21 downto 0);
		end if;
	else
		c1_out <= X"0000000000000000";
		--c2_out <= X"0000000000000000";
		
	 end if;
	
	if C2out = '1' then
		if D(16) = '1' then
			c2_out <= "11111111111111111111111111111111111111111111111" & D (16 downto 0);
		elsif D(16) = '0' then
			c2_out <= "00000000000000000000000000000000000000000000000" & D (16 downto 0);
		end if;
	else
		--c1_out <= X"0000000000000000";
		c2_out <= X"0000000000000000";
	end if;
	
end process;
end Behavioral;

