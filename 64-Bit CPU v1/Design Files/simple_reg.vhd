library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity simple_reg is
	port(D : in std_logic_vector (63 downto 0);
	     Q : out std_logic_vector (63 downto 0);
	     clk: in std_logic);
end simple_reg;

architecture behavioral of simple_reg is
begin
	process (clk)
	begin
		if (clk'event AND clk = '1') then		-- On rising clock edge, input is transferred into register
			Q <= D;
		end if;
	end process;
end behavioral;


