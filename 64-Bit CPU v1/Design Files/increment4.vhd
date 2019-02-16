library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity increment4 is
    Port ( InpA : in  STD_LOGIC_VECTOR (63 downto 0);
           OutpA : out  STD_LOGIC_VECTOR (63 downto 0));
end increment4;

architecture Behavioral of increment4 is

signal int_sig: std_logic_vector (63 downto 0) := x"0000000000000000";

begin
	int_sig <= InpA;	
	--OutpA <= std_logic_vector(to_unsigned(to_integer(unsigned( int_sig )) + 4, 64));
	OutpA <= std_logic_vector(unsigned(int_sig) + 4);
end Behavioral;

