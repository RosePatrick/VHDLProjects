
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplexer is
port ( Inp0, Inp1, Inp2: in std_logic_vector (63 downto 0); --Inp3 is disabled temporarily
		sel : in std_logic_vector (1 downto 0);
		Outp : out std_logic_vector (63 downto 0));
end multiplexer;

architecture Behavioral of multiplexer is

begin
process (sel, Inp0, Inp1, Inp2)
	begin
		case sel is
			when "00" => Outp <= Inp0;  --Input 0 is enabled
			when "01" => Outp <= Inp1;  --Input 1 is enabled
			when "10" => Outp <= Inp2;	 --Input 2 is enabled
			when others => Outp <= X"0000000000000000";
		end case;
	end process;
end Behavioral;

