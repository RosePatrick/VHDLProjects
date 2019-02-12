----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Rose-Marie Patrick
-- 
-- Create Date: 02/11/2019 02:40:35 PM
-- Design Name: Simple Pushbutton Debounce Circuit
-- Module Name: debounce - Behavioral
-- Project Name: Seven Segment Display Counter
-- Target Devices: Basys 3 Artix 7
-- Tool Versions: 
-- Description: Circuit design adapted from allaboutfpga.com
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

entity debounce is
    Port ( clk : in STD_LOGIC;
           btnU : in STD_LOGIC;
           db_signal : out STD_LOGIC);
end debounce;

architecture Behavioral of debounce is
signal ff1, ff2, ff3 : std_logic;               -- 3 flip flop circuits
begin

    process (clk)
    begin  
        if (clk'event and clk = '1') then
            ff1 <= btnU;                        --cascade 3 flip flops
            ff2 <= ff1;
            ff3 <= ff2;
        end if;
    end process;
    db_signal <= ff1 and ff2 and ff3;           --AND outputs of 3 flip flops and output debounced signal
end Behavioral;
