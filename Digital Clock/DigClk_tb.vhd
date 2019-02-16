----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/15/2019 01:20:51 PM
-- Design Name: 
-- Module Name: DigClk_tb - Behavioral
-- Project Name: 
-- Target Devices: 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DigClk_tb is
--  Port ( );
end DigClk_tb;

architecture Behavioral of DigClk_tb is

component DigClk is
Port ( clk : in STD_LOGIC;
       seg : out STD_LOGIC_VECTOR (6 downto 0);
       an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal clk : std_logic;
signal seg : STD_LOGIC_VECTOR (6 downto 0);
signal an : STD_LOGIC_VECTOR (3 downto 0);

begin

uut: DigClk port map(
    clk => clk,
    seg => seg,
    an => an);
    
    
Clock: process
      begin
           clk <= '1';
           wait for 5ns;
           clk <= '0';
           wait for 5ns;
      end process;
      
stimulus: process
        begin
            wait for 200 ns;
            wait;
        end process;

end Behavioral;
