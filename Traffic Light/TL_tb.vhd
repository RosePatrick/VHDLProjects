----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/26/2019 09:06:12 PM
-- Design Name: 
-- Module Name: TL_tb - Behavioral
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

entity TL_tb is
--  Port ( );
end TL_tb;

architecture Behavioral of TL_tb is

component TLControl is
    Port ( clk, reset : in STD_LOGIC;
           main_trafficl : out std_logic_vector(2 downto 0);
           secondary_trafficl : out std_logic_vector(2 downto 0));
end component;

signal clk, reset : std_logic;
signal main_trafficl, secondary_trafficl : std_logic_vector (2 downto 0);

begin

uut: TLControl port map (
     clk => clk,
     reset => reset,
     main_trafficl => main_trafficl,
     secondary_trafficl => secondary_trafficl);
     
Clock: process
  begin
       clk <= '1';
       wait for 5ns;
       clk <= '0';
       wait for 5ns;
  end process;

stimulus: process
  begin
      wait for 50 ns;
      reset <= '1';
      wait for 40 ns;
      reset <= '0';
      wait for 200us;
      wait;
  end process;

end Behavioral;
