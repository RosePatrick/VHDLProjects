library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity my_shifter is
port (A: in std_logic_vector(63 downto 0);
		opcode : in std_logic_vector (4 downto 0);
		count: in std_logic_vector(5 downto 0);
		C: out std_logic_vector(63 downto 0));
end my_shifter;

architecture Behavioral of my_shifter is

begin
	process (A, opcode, count) 
	begin
		case opcode is
			when "00101" => C <= to_stdlogicvector(to_bitvector(A) sra to_integer(unsigned(count)));	-- Arithmetic shift right
			when "00110" => C <= to_stdlogicvector(to_bitvector(A) sla to_integer(unsigned(count)));	-- Arithmetic shift left
			when "00111" => C <= to_stdlogicvector(to_bitvector(A) srl to_integer(unsigned(count)));	-- Logical shift right	
			when "01000" => C <= to_stdlogicvector(to_bitvector(A) sll to_integer(unsigned(count)));	-- Logical shift left			
			when "01001" => C <= to_stdlogicvector(to_bitvector(A) ror to_integer(unsigned(count)));	-- Rotate right
			when "01010" => C <= to_stdlogicvector(to_bitvector(A) rol to_integer(unsigned(count)));	-- Rotate left
			when others => C <= X"0000000000000000";
		end case;
	end process;	
end Behavioral;

