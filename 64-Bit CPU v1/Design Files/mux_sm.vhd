library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux_sm is
port ( In1, In2: in std_logic_vector (4 downto 0);
		sel : in std_logic;
		Outp : out std_logic_vector (4 downto 0));
end mux_sm;

architecture Behavioral of mux_sm is

begin
process (sel, In1, In2)
	begin
		case sel is
			when '0' => Outp <= In1;
			when '1' => Outp <= In2;	
			when others => NULL;
		end case;
	end process;

end Behavioral;

