library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Data_mem is
port (Dbus, Drd, Strobe, Dwr, Dout, Ain, clk : in std_logic;
		Datain, Addrin: in std_logic_vector (63 downto 0);
		Mbus: inout std_logic_vector (63 downto 0);
		Addrout, Dataout: out std_logic_vector (63 downto 0));
end Data_mem;

architecture Behavioral of Data_mem is

component gp_register
	port(D : in std_logic_vector (63 downto 0);
	     Q : out std_logic_vector (63 downto 0);
	     en, wr, clk: in std_logic);
end component;

component simple_reg is
	port(D : in std_logic_vector (63 downto 0);
	     Q : out std_logic_vector (63 downto 0);
	     clk: in std_logic);
end component;

signal MDin, MDout : std_logic_vector(63 downto 0);
signal sig1, sig2, sig3, sig4 : std_logic_vector (63 downto 0);
signal clk_en_sig : std_logic;
begin	

MA : gp_register port map(
		D => Addrin,	  -- from internal bus
		Q => Addrout,    -- to memory bus 
		en => Ain,
		wr => Ain,
		clk => clk);

MD : simple_reg port map(
		D => MDin,
		Q => MDout,
		clk => clk_en_sig);
		
process (Dbus, Drd, Dout, Dwr, Strobe, Datain, Mbus, MDout, sig1, sig2, sig3, sig4)
begin
	
	sig1 <= (others => Dbus);
	sig2 <= Datain and sig1;
	sig3 <= (others => Drd);
	sig4 <= Mbus and sig3;
	
	MDin <= sig2 or sig4;

	clk_en_sig <= Strobe AND (Dbus OR Drd);

	if (Dout = '1') then
		Dataout <= MDout;
	elsif (Dwr = '1') then
		Mbus <= MDout;
		end if;
	
end process;
end Behavioral;

