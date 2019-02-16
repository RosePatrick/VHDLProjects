library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gp_register is
	port(D : in std_logic_vector (63 downto 0);
	     Q : out std_logic_vector (63 downto 0);
	     en, wr, clk: in std_logic);
end gp_register;

architecture behavioral of gp_register is
signal int_Q : std_logic_vector (63 downto 0);
begin
	process (en, wr, clk, D, int_Q)
	begin
			if ((en AND clk AND wr) = '1') then
				int_Q <= D;
			elsif (en = '1') then
				Q <= int_Q;
			end if;
	end process;
end behavioral;


