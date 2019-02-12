----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Rose-Marie Patrick
-- 
-- Create Date: 09/25/2018 07:37:56 PM
-- Design Name: N-Tap FIR Filter
-- Module Name: FFilter - Behavioral
-- Project Name: N-Tap FIR Filter
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

entity FFilter is
generic (
        in_bus_width : integer := 8;            -- bus width for input data
        taps : integer := 4;                    -- number of taps for filter
        coeff_width : integer := 8             -- bit width of filter coefficients
);
Port(
        inp_data:   in std_logic_vector (in_bus_width-1 downto 0);
        coeffs:     in std_logic_vector(coeff_width-1 downto 0);
        clk :       in std_logic;
        reset:      in std_logic;
        out_data: 	out std_logic_vector((in_bus_width + coeff_width + integer(ceil(log2(real(taps)))) - 1) downto 0));
end FFilter;

architecture Behavioral of FFilter is

type arr_coeff is array (0 to taps-1) of std_logic_vector(coeff_width-1 downto 0);
type arr_signal is array (0 to taps-1) of signed(in_bus_width-1 downto 0);
signal coeff_s : arr_coeff;
signal data_s : arr_signal;

begin
    process (clk, reset)
    
    variable out_s : signed ((in_bus_width + coeff_width + integer(ceil(log2(real(taps)))) - 1) downto 0);
    variable i : integer :=0;
    
        begin
            if (reset = '1') then                                       -- On asynch reset, clear internal signals
                coeff_s <= (others => (others => '0'));
                data_s <= (others => (others => '0'));
                
            elsif (rising_edge(clk))then
          
            if (i < taps) then
                coeff_s(i) <= coeffs;                                   -- read in filter coefficients
                i := i+1;
             end if;   

            data_s <= signed(inp_data) &  data_s(0 to taps-2);          -- read input signal data into register pipeline

                
            out_s := (others => '0');
            for i in 0 to taps-1 loop                                   -- multiply input data by filter coefficients and sum to get output
                out_s := out_s + (data_s(i) * signed(coeff_s(i)));
            end loop;
            
            out_data <= std_logic_vector(out_s);                        -- convert calculated signed output to std_logic_vector and output
            end if;
    end process;

end Behavioral;
