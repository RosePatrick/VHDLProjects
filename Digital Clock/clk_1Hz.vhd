----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Rose-Marie Patrick
-- 
-- Create Date: 02/15/2019 02:40:13 PM
-- Design Name: 1 Hz Clock Generator
-- Module Name: clk_1Hz - Behavioral
-- Project Name: Digital Clock
-- Target Devices: Basys 3 Artix 7
-- Tool Versions: 
-- Description: Generate a 1Hz Clock from the system 100MHz clock
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

entity clk_1Hz is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_1Hz : out STD_LOGIC);
end clk_1Hz;

architecture Behavioral of clk_1Hz is

signal count : integer := 0;
constant maxcnt : integer := 50000000;                  ---- 100 000 000 Hz / 50 000 000 per half cycle
signal clk_sig : std_logic := '0';

begin

    process (clk)                           
    begin           
        if (clk'event and clk = '1') then
            if (reset = '1' or count = maxcnt) then
                count <= 0;
                clk_sig <= not clk_sig;                 ---- Clock divider ---> Generate 1 Hz Clock Signal
            else 
                count <= count + 1;
            end if;
        end if;
    end process;
    
    clk_1Hz <= clk_sig;

end Behavioral;
