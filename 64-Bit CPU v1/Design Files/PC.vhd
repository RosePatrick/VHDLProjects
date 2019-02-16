library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC is
    Port ( Inp : in  STD_LOGIC_VECTOR (63 downto 0);
			  clk : in std_logic;
           Outp1 : out  STD_LOGIC_VECTOR (63 downto 0));
end PC;

architecture Behavioral of PC is

begin
	process (clk)
	begin
		if (clk'event AND clk = '1') then
				Outp1 <= Inp;
		end if;
	end process;

end Behavioral;

