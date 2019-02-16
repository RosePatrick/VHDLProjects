----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Rose-Marie Patrick
-- 
-- Create Date: 02/12/2019 08:29:08 PM
-- Design Name: Digital Clock (12-Hour format)
-- Module Name: DigClk - Behavioral
-- Project Name: Digital Clock
-- Target Devices: Basys 3 Artix 7
-- Tool Versions: 
-- Description: Implementation of a 12 hour digital clock, displaying hours and minutes
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
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DigClk is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           dp : out STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end DigClk;

architecture Behavioral of DigClk is

component ss_driver is                      -- Seven Segment driver
    Port ( inp : in STD_LOGIC_VECTOR (3 downto 0);
           out_seg : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component clk_1Hz is                        --1 Hz Clock generator
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_1Hz : out STD_LOGIC);
end component;

constant max : integer := 10000;
signal minute, second : integer := 0;
signal hour : integer := 12;
signal count4 : integer := 0;
signal clk_signal, dp_signal : std_logic;
signal switch : std_logic_vector (3 downto 0) := "1110";
signal digits : std_logic_vector (3 downto 0):= "0000";
signal segm_ones, segm_tens, segh_ones, segh_tens : std_logic_vector(3 downto 0);
signal clk_div : unsigned (20 downto 0) := (others => '0');

begin
SS: ss_driver Port Map(
    inp => digits,
    out_seg => seg);

CK: clk_1Hz Port Map(
    clk => clk,
    reset => reset,
    clk_1Hz => clk_signal);
    
    process (clk)                           
    begin           
        if (clk'event and clk = '1') then
             if (clk_div = max) then                ---Refresh rate counter for Seven Segment LED
                clk_div <= (others => '0');
                if (count4 = 4) then                --- Counter for anode enable
                   count4 <= 0;
                else
                   count4 <= count4 + 1;
                end if;
             else
                    clk_div <= clk_div + 1;
             end if;
         end if;   
                 
            case count4 is                                           ---Enable each of the seven segment digits
                when 0 => switch <= "1110"; digits <= segm_ones; dp_signal <= '1';
                when 1 => switch <= "1101"; digits <= segm_tens; dp_signal <= '1';
                when 2 => switch <= "1011"; digits <= segh_ones; dp_signal <= not clk_signal;
                when 3 => switch <= "0111"; digits <= segh_tens; dp_signal <= '1';
                when others => switch  <= "1111"; dp_signal <= '1';
            end case;
            
            if (rising_edge(clk_signal)) then                   ---Determine second, minute and hour count
               second <= second + 1;
               if (second >= 59) then
                   second <= 0;
                   minute <= minute + 1;
                   if (minute >= 59) then
                       minute <= 0;
                       hour <= hour + 1;
                       if (hour >= 12) then
                           hour <= 1;
                       end if;
                   end if;
               end if;
            end if;
    end process;
     
segm_ones <= std_logic_vector (to_unsigned(minute mod 10,4));      -- ones digit       ---Calculate minute and hour digits
segm_tens <= std_logic_vector (to_unsigned(minute/10, 4));         -- tens digit
segh_ones <= std_logic_vector (to_unsigned(hour mod 10, 4));       -- ones digit 
segh_tens <= std_logic_vector (to_unsigned(hour/10, 4));           -- tens digit
an <= switch;                                                      -- anode enable signals
dp <= dp_signal;                                                   -- decimal point signal (second counter)

end Behavioral;
