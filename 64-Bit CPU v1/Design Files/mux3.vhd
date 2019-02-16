library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux3 is
port (Inp0, Inp1, Inp2: in std_logic_vector (63 downto 0);
		sel : in std_logic_vector (1 downto 0);
		Outp : out std_logic_vector (63 downto 0));
end mux3;

architecture Behavioral of mux3 is

begin
process (sel, Inp0, Inp1, Inp2)
	begin
		case sel is
			when "00" => Outp <= Inp0;
			when "01" => Outp <= Inp1;
			when "10" => Outp <= Inp2;
			when "11" => NULL;               ---- Check if this works
			when others => NULL;
		end case;
	end process;

end Behavioral;

