library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu_decoder is
    Port ( inp : in  STD_LOGIC_VECTOR (4 downto 0);
			  mux_en : out std_logic_vector (1 downto 0));
end alu_decoder;

architecture Behavioral of alu_decoder is

begin

process (inp)
	begin
		  case inp is
				when "00001" => mux_en <= "11";		-- Add
				when "10101" => mux_en <= "11";		-- Addi
				when "00010" => mux_en <= "11";		-- Sub
				when "10001" => mux_en <= "11";		-- Inc
				when "10010" => mux_en <= "11";		-- Dec
				when "01110" => mux_en <= "11";		-- Load (find displacement address)
				when "01111" => mux_en <= "11";		-- Store (find displacement address)
				when "10100" => mux_en <= "11";		-- Branch conditional (find displacement address)
				when "10011" => mux_en <= "11";		-- Branch  (find displacement address)
-------------------------------------------------------------------------				
				when "01011" => mux_en <= "01"; 		-- AND
				when "10110" => mux_en <= "01";		-- ANDI
				when "01100" => mux_en <= "01";		-- OR
				when "10111" => mux_en <= "01"; 		-- ORI
				when "01101" => mux_en <= "01"; 		-- NOT
--------------------------------------------------------------------------			
				when "00101" => mux_en <= "10";		-- Arithmetic shift right
				when "00110" => mux_en <= "10";		-- Arithmetic shift left
				when "00111" => mux_en <= "10";		-- Logical shift right	
				when "01000" => mux_en <= "10";		-- Logical shift left			
				when "01001" => mux_en <= "10";		-- Rotate right
				when "01010" => mux_en <= "10";		-- Rotate left
	
            when others => NULL;
		  end case;
		  
	end process;


end Behavioral;

