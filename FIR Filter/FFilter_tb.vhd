----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/26/2018 01:20:05 PM
-- Design Name: 
-- Module Name: FFilter_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use ieee.MATH_REAL.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FFilter_tb is
end FFilter_tb;

architecture Behavioral of FFilter_tb is
component FFilter is
generic (
        in_bus_width : integer := 8;           -- bus width for input data
        taps : integer := 4;                -- number of taps for filter
        coeff_width : integer := 8           -- bit width of filter coefficients
);
Port(
        inp_data:   in std_logic_vector (in_bus_width-1 downto 0);
        coeffs:     in std_logic_vector(coeff_width-1 downto 0);
        clk :       in std_logic;
        reset:      in std_logic;
        --out_data:   out std_logic_vector(out_bus_width-1 downto 0));
        out_data:   out std_logic_vector((in_bus_width + coeff_width + integer(ceil(log2(real(taps)))) - 1) downto 0));
end component;

constant in_bus_width  : integer := 8;
constant taps : integer := 4;
constant coeff_width : integer := 8;

signal inp_data	: std_logic_vector (in_bus_width-1 downto 0) := (others => '0');
signal out_data: std_logic_vector((in_bus_width + coeff_width + integer(ceil(log2(real(taps)))) - 1) downto 0);
signal coeffs : std_logic_vector(coeff_width-1 downto 0);
signal reset : std_logic := '1';
signal clk : std_logic :='0';

begin

dev_to_test : FFilter 
	generic map (
		in_bus_width => in_bus_width,
		taps => taps,
		coeff_width => coeff_width)
	port map (
		inp_data => inp_data,
		coeffs => coeffs,
		out_data => out_data,
		clk => clk,
		reset => reset);
	
clk_proc : process
  begin
      wait for 10 ns;
      clk <= not clk;
end process clk_proc;

reset_proc : process
  begin
      wait for 15 ns;
      reset <= '0';
end process reset_proc;

stimulus : process
begin
    wait for 20 ns;                     --intake filter coefficients
    coeffs <= "00000001";
    wait for 20 ns;
    coeffs <= "00000010";
    wait for 20 ns;
    coeffs <= "00000011";
    wait for 20 ns;
    coeffs <= "00000100";
    wait for 20 ns;
    inp_data <= "00000001";             --intake input signal data
    wait for 20 ns;
    inp_data <= "00000010";
    wait for 20 ns;
    inp_data <= "00000100";
    wait for 20 ns;
    inp_data <= "00000011";
    wait for 20 ns;
    inp_data <= "00000001";
    wait for 20 ns;
    inp_data <= "00000000";
    
    wait for 100ns;
end process stimulus;
	
end Behavioral;
