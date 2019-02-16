----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Rose-Marie Patrick
-- 
-- Create Date: 01/30/2019 10:35:49 PM
-- Design Name: Seven Segment Display Driver
-- Module Name: ss_driver - Behavioral
-- Project Name: 
-- Target Devices: Basys 3 Artix 7
-- Tool Versions: 
-- Description: This module takes a 4-bit input and converts it to seven segment display signals.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ss_driver is
    Port ( inp : in STD_LOGIC_VECTOR (3 downto 0);
           out_seg : out STD_LOGIC_VECTOR (6 downto 0));
end ss_driver;

architecture Behavioral of ss_driver is

signal s_outp : std_logic_vector (6 downto 0);

begin
-----------------------------------------
-- Seven Segment Display (for reference)
--
--			   0
--			 -----
--			|	  |
--		  5 |     | 1
--			|  6  |
--			 -----
--			|	  |
--		  4 |     | 2
--			|	  |
--			 -----
--			   3
-----------------------------------------
--Take 4-bit input and convert to 7 segment output. LEDs are active low and are lit with a '0' bit
    ss_process: process (inp)
        begin
        case inp is 
            when "0000" => s_outp <= "1000000";     -- 0    -- output numbering in the format MSB to LSB (from bit 6 down to 0)
            when "0001" => s_outp <= "1111001";     -- 1
            when "0010" => s_outp <= "0100100";     -- 2
            when "0011" => s_outp <= "0110000";     -- 3
            when "0100" => s_outp <= "0011001";     -- 4
            when "0101" => s_outp <= "0010010";     -- 5
            when "0110" => s_outp <= "0000010";     -- 6
            when "0111" => s_outp <= "1111000";     -- 7
            when "1000" => s_outp <= "0000000";     -- 8
            when "1001" => s_outp <= "0010000";     -- 9
            when others => s_outp <= (others => 'X');
        end case;
    end process ss_process;
    
    out_seg <= s_outp;          -- assign signal to output port

end Behavioral;
