library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity logic_unit is
port(A,B : in std_logic_vector(63 downto 0);
	  opcode : in std_logic_vector (4 downto 0);
     C : out std_logic_vector(63 downto 0));
end logic_unit;

architecture Behavioral of logic_unit is

begin
process(opcode, A, B)
begin
  case opcode is
		when "01011" => C <= A and B; -- AND
		when "10110" => C <= A and B; -- ANDI
		when "01100" => C <= A or B; --OR
		when "10111" => C <= A or B; --ORI
		when "01101" => C <= not A; --NOT
		when others => C <= X"0000000000000000";
  end case;  
end process;    


end Behavioral;

