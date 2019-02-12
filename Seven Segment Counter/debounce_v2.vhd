----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Rose-Marie Patrick
-- 
-- Create Date: 02/11/2019 02:40:35 PM
-- Design Name: Simple Pushbutton Debounce Circuit
-- Module Name: debounce - Behavioral (version 2)
-- Project Name: Seven Segment Display Counter
-- Target Devices: Basys 3 Artix 7
-- Tool Versions: 
-- Description: Circuit design adapted from fpga4student.com
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
use IEEE.NUMERIC_STD.ALL;

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
signal ff1, ff2, clk_1kHz : std_logic;              -- 2 flip flop circuits
signal counter : unsigned (16 downto 0);
signal maxcount : integer := 100000;                -- 100,000,000 Hz clock/100,000 = 1000 Hz
begin

    process (clk)
    begin  
        if (clk'event and clk = '1') then           -- clock divider --> 100 MHz to 1kHz
            if (counter = maxcount) then
                counter <= (others => '0');
                clk_1khz <= not clk_1khz;
             else
                counter <= counter + 1;
            end if;
        end if;
     end process;
     
     process (clk_1kHz)
     begin
        if (rising_edge(clk_1khz)) then         --use slower clock in button debounce
            ff1 <= btnU;                        --cascade 2 flip flops
            ff2 <= ff1;
        end if;
    end process;
    db_signal <= ff1 and (not ff2);           --AND outputs of 2 flip flops and output debounced signal
end Behavioral;
