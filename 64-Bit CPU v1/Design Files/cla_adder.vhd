library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cla_adder is
port (A: in std_logic_vector(63 downto 0);
		B: in std_logic_vector (63 downto 0);
		opcode : in std_logic_vector (4 downto 0);
		S: out std_logic_vector (63 downto 0);
		flags: inout std_logic_vector (3 downto 0) );		--Carry, Overflow, Negative, Zero
end cla_adder;

architecture Behavioral of cla_adder is

signal carry_in, carry_out: std_logic;
signal c_gen: std_logic_vector (63 downto 0);
signal c_prop: std_logic_vector (63 downto 0);
signal c_in_sig: std_logic_vector (63 downto 0);
signal sum_sig: std_logic_vector (63 downto 0);
signal Bsig: std_logic_vector (63 downto 0);

constant pos_one : std_logic_vector := X"0000000000000001";
constant neg_one : std_logic_vector := X"FFFFFFFFFFFFFFFF";

begin
	process (sum_sig, c_gen, c_prop, c_in_sig, Bsig, A, B, opcode, carry_in, carry_out)
		begin
				if opcode = "00001" or 
					opcode = "01110" or 
					opcode = "01111" or									-- Add
					opcode = "10011" or
					opcode = "10100" then
					Bsig <= B;								
				elsif opcode = "10101" then							-- Addi
					Bsig <= B;
				elsif opcode = "00010" then							-- Subtraction
					Bsig <= std_logic_vector(unsigned(NOT B) + 1);  -- negate B
				elsif opcode = "10001" then							-- Increment
					Bsig <= pos_one;
				elsif opcode = "10010" then							-- Decrement
					Bsig <= neg_one;
				end if;
				
			carry_in <= '0';
			c_prop <= A XOR Bsig;
			c_gen <= A AND Bsig;
			c_in_sig (0) <= carry_in;
				for I in 0 to 62 loop
					sum_sig(I) <= c_prop(I) xor c_in_sig(I);
					c_in_sig(I+1) <= c_gen(I) or (c_prop(I) and c_in_sig(I));
				end loop;
				sum_sig(63) <= c_prop(63) xor c_in_sig(63);
				carry_out <= c_gen(63) or (c_prop(63) and c_in_sig(63));

		if sum_sig = X"0000000000000000" then
			flags(0) <= '1';
		else
			flags(0) <= '0';
		end if;
		if sum_sig(63) = '1' then
			flags(1) <= '1';
		else
			flags(1) <= '0';
		end if;
		if carry_out ='1' then
			flags(3) <= '1';
		else
			flags(3) <= '0';
		end if;

-- Determine overflow conditions
if opcode = "00001" then
	if A(63) = '0' and Bsig(63) = '0' and sum_sig(63) = '1' then
		flags(2) <= '1';
	elsif A(63) = '1' and Bsig(63) = '1' and sum_sig(63) = '0' then
		flags(2) <= '1';
	--else flags (2) <= '0';
	end if;
elsif opcode = "00010" then
	if A(63) = '0' and Bsig(63) = '1' and sum_sig(63) = '1' then
		flags(2) <= '1';
	elsif A(63) = '1' and Bsig(63) = '0' and sum_sig(63) = '0' then
		flags(2) <= '1';
	--else flags (2) <= '0';
	end if;
	else flags (2) <= '0';
end if;


		end process;
		
	S <= sum_sig;
	
end Behavioral;


