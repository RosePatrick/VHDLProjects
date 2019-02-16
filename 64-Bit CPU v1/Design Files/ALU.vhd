library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cpu_alu is
port (A: in std_logic_vector(63 downto 0);
		B: in std_logic_vector (63 downto 0);
		opcode: in std_logic_vector (4 downto 0);
		count: in std_logic_vector (5 downto 0);
		flags: inout std_logic_vector(3 downto 0);		--Carry, Overflow, Negative, Zero
		Y : out std_logic_vector (63 downto 0));
end cpu_alu;

architecture behavioral of cpu_alu is

-- internal signals
signal adder,logic, shifter, BReg : std_logic_vector (63 downto 0);    --
signal msel : std_logic_vector (1 downto 0);

component logic_unit is
port(A,B : in std_logic_vector(63 downto 0);
	  opcode : in std_logic_vector (4 downto 0);
     C : out std_logic_vector(63 downto 0));
end component;

component cla_adder is
port (A: in std_logic_vector(63 downto 0);
		B: in std_logic_vector (63 downto 0);
		opcode : in std_logic_vector (4 downto 0);
		S: out std_logic_vector (63 downto 0);
		flags: inout std_logic_vector (3 downto 0) );		--Carry, Overflow, Negative, Zero
end component;

component my_shifter is
port (A: in std_logic_vector(63 downto 0);
		opcode : in std_logic_vector (4 downto 0);
		count: in std_logic_vector(5 downto 0);
		C: out std_logic_vector(63 downto 0));
end component;

component alu_decoder is
    Port ( inp : in  STD_LOGIC_VECTOR (4 downto 0);
			  mux_en : out std_logic_vector (1 downto 0));
end component;


begin
ALU_DECODE : alu_decoder port map(
				inp => opcode,
				mux_en => msel);
				
ALU_UNIT1 : cla_adder port map(						-- adder/subtractor
				A => A,
				B => B,
				opcode => opcode,
				S => adder,
				flags => flags);			

ALU_UNIT3 : my_shifter port map (					-- shifter
				A=> A,
				opcode => opcode,
				count => count,
				C => shifter);

ALU_UNIT4 : logic_unit port map(						-- logic unit
				A => A,
				B => B,
				opcode => opcode,
				C => logic);
				
Breg <= B;
process (opcode, B, msel, BReg, logic, shifter, adder)
begin	
	if opcode = "10000" then
		Y <= BReg;
	end if;

	case msel is 
		when "00" => Y <= X"0000000000000000";
		when "01" => Y <= logic;
		when "10" => Y <= shifter;
		when "11" => Y <= adder;
		when others => Y <= X"0000000000000000";
	end case;
end process;

end behavioral;
