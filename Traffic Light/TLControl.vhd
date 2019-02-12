----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Rose-Marie Patrick
-- 
-- Create Date: 01/25/2019 09:08:03 PM
-- Design Name: Traffic Light Controller
-- Module Name: TLControl - Behavioral
-- Project Name: 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TLControl is
    Port ( clk, reset : in STD_LOGIC;
           main_trafficl : out std_logic_vector(2 downto 0);
           secondary_trafficl : out std_logic_vector(2 downto 0));
end TLControl;

architecture Behavioral of TLControl is

---Types and signal declarations
type state_type is (S0, S1, S2, S3, SR);
signal current_state : state_type;
signal next_state : state_type := S0;
signal timeout10, timeout3, en_3: std_logic := '0';
signal en_10 : std_logic := '1';
signal count10, count3 : integer := 0;
constant ten_count : integer   := 1000000000; --10 second delay
constant three_count : integer := 300000000;  -- 3 second delay

begin

process (clk)
begin
    if (clk'event and clk = '1') then
        if (reset = '1') then           --synchronous reset 
            current_state <= SR;
            count10 <= 0;
            count3 <= 0;
        else
            current_state <= next_state;
        end if;
        
        ----------------Getting a 10 second delay------------------------------
        if (en_10 = '1') then
            if (count10 >= ten_count) then
                count10 <= 0;
                timeout10 <= '1' ;
            else
                count10 <= count10 + 1;
            end if;  
        else
            count10 <= 0;
            timeout10 <= '0' ;
        end if;
        
         ----------------Getting a 3 second delay-------------------------    
        if (en_3 = '1') then   
            if (count3 >= three_count) then
                count3 <= 0;
                timeout3 <= '1' ;
            else
                count3 <= count3 + 1;
            end if;
         else
            count3 <= 0;
            timeout3 <= '0' ;
         end if;
         
         ------------------Traffic Light State Transitions-----------------
        case current_state is 
            when SR =>                                      -- on reset, disable counters
                en_10 <= '0';
                en_3 <= '0';
                main_trafficl  <= "100";
                secondary_trafficl <= "001";
                next_state <= S0;
            
            when S0=>
                en_10 <= '1';                               -- Main street on green light, secondary road on red light
                main_trafficl  <= "100";
                secondary_trafficl <= "001";
                if (timeout10 = '1') then                   -- if ten seconds have elapsed, go to next state
                    next_state <= S1;
                    en_10 <= '0';                           -- 10 second delay disabled
                    en_3 <= '1';                            -- 3 second delay enabled
                else
                    next_state <= S0;
                end if;
        
            when S1=>
                main_trafficl  <= "010";                    --- main road on yellow, secondary road on red
                secondary_trafficl <= "001";
                if (timeout3 = '1') then                    -- if three seconds have elapsed, go to next state
                    next_state <= S2;
                    en_10 <= '1';                           -- 10 second delay enabled
                    en_3 <= '0';                            -- 3 second delay disabled
                else
                    next_state <= S1;
                end if;
            
            when S2=>
                main_trafficl  <= "001";                --- main road on red, secondary road on green
                secondary_trafficl <= "100"; 
                if (timeout10 = '1') then
                    next_state <= S3;
                    en_10 <= '0';                           -- 10 second delay disabled
                    en_3 <= '1';                            -- 3 second delay enabled
                else
                    next_state <= S2;
                end if;
      
            when S3 =>
                main_trafficl  <= "001";
                secondary_trafficl <= "010";            --- main road on red, secondary road on yellow
                if (timeout3 = '1') then
                    next_state <= S0;
                    en_10 <= '1';                           -- 10 second delay enabled
                    en_3 <= '0';                            -- 3 second delay disabled
                else
                    next_state <= S3;
                end if;
                        
        end case;  
    end if;
end process;

end Behavioral;
