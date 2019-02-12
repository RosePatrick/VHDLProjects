----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Rose-Marie Patrick
-- 
-- Create Date: 01/30/2019 11:15:01 PM
-- Design Name: Seven Segment Display - Top File
-- Module Name: ss_top - Behavioral
-- Project Name: Seven Segment Display Counter 
-- Target Devices: Basys 3 Artix 7
-- Tool Versions: 
-- Description: 
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

entity ss_top is
  Port (sw : in std_logic;
  clk : in std_logic;
  an : out std_logic_vector(3 downto 0);
  seg : out std_logic_vector(6 downto 0));
end ss_top;

architecture Behavioral of ss_top is

----------Component and signal declarations-----------------------
component ss_driver is
    Port ( inp : in STD_LOGIC_VECTOR (3 downto 0);
           out_seg : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component debounce is
    Port ( clk : in STD_LOGIC;
           btnU : in STD_LOGIC;
           db_signal : out STD_LOGIC);
 end component;

signal pb_count : integer := 0;
signal clk_div : unsigned (20 downto 0);
constant max : integer := 20000; ---500 Hz refresh rate
constant max_num : integer := 99; -- using only 2 of the 4 digits for seven segment display - max number that can be displayed is 99
signal ones, tens : std_logic_vector (3 downto 0);
signal db_sig : std_logic;
signal switch : std_logic_vector (1 downto 0) := "10";
signal seg_ones, seg_tens : std_logic_vector(6 downto 0);
------------------------------------------------------------------

begin
SS1: ss_driver Port map (
    inp => ones,
    out_seg => seg_ones);

SS2: ss_driver Port map (
     inp => tens,
     out_seg => seg_tens);

DB: debounce Port map(
    clk => clk,
    btnU => sw,
    db_signal => db_sig);
    
    process (clk)
    begin
        if (clk'event and clk = '1') then
            if (clk_div = max) then
                clk_div <= (others => '0');
                switch <= not switch;
            else
                clk_div <= clk_div + 1;
            end if;
        end if;
    end process;

    process (db_sig, switch, pb_count)                                        --increment count each time the button is pressed
        begin                                 
            if (rising_edge(db_sig)) then                           --debounced button signal is counted
               if (pb_count = max_num) then
                    pb_count <= 0;
                else           
                    pb_count <= pb_count + 1;
                end if;
            end if;
     
            if (switch(0) = '0') then                               -- if 'ones' seven segment is enabled, output ones digit
                seg <= seg_ones;
            else 
                seg <= seg_tens;                                    -- else output tens digit
            end if;
            
    end process;
    
--convert signal to compatible format and map to seven segment driver        
    ones <= std_logic_vector (to_unsigned(pb_count mod 10, 4));      -- ones digit 
    tens <= std_logic_vector (to_unsigned(pb_count/10, 4));          -- tens digit
    an(3 downto 2) <= "11";
    an(1 downto 0) <= switch;                                        -- enable seven segment displays (only two digits)

end Behavioral;
