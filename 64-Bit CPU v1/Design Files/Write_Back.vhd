library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Write_Back is
port( Z4, MD4 : in std_logic_vector (63 downto 0);
		IR4 : in std_logic_vector (31 downto 0);
		RD, WR : out std_logic;
		Done, clk : in std_logic;
		Mbus: inout std_logic_vector (63 downto 0);
		IR5 : out std_logic_vector (31 downto 0);
		Z5, Addrout : out std_logic_vector (63 downto 0));
end Write_Back;

architecture Behavioral of Write_Back is

component Data_mem is
port (Dbus, Drd, Strobe, Dwr, Dout, Ain, clk : in std_logic;		-- Memory control signals 
		Datain, Addrin: in std_logic_vector (63 downto 0);				--- Obtained internally
		Mbus: inout std_logic_vector (63 downto 0);
		Addrout, Dataout: out std_logic_vector (63 downto 0));
end component;

component mux2 is
port ( In1, In2: in std_logic_vector (63 downto 0);
		sel : in std_logic;
		Outp : out std_logic_vector (63 downto 0));
end component;

signal mp5_sel, Dbus, Drd, Strobe, Dwr, Dout, Ain : std_logic;
signal Memdata : std_logic_vector(63 downto 0);
signal opcode : std_logic_vector (4 downto 0);

begin

MP5 : mux2 port map(
		In1 => Z4,									--- If instruction is not load
		In2 => Memdata,							--- If instruction is load
		sel => mp5_sel,
		Outp => Z5);

DM : 	Data_mem port map(
		Dbus => Dbus, 								-- MDin signal from control unit
		Drd => Drd,  								-- Signal from memory
		Strobe => Strobe,							-- Signal from memory
		Dwr => Dwr,  								-- Signal from memory
		Dout => Dout, 								-- MDout Signal from control unit
		Ain => Ain, 								-- MAin Signal from control unit
		clk => clk,									-- clock signal
		Datain => MD4, 							-- Data to be stored in/received from memory
		Addrin => Z4,								-- Address of data to be stored in/received from memory
		Mbus => Mbus,								-- Memory data bus
		Addrout => Addrout,						-- Memory address bus
		Dataout => Memdata);						-- Memory data to CPU bus

opcode <= IR4(31 downto 27);

process (clk, opcode, Done)
begin
	if clk'event and clk = '1' then
		IR5 <= IR4;
	end if;
	if opcode = "01110" then 					-- if instruction is Load
		Ain <= '1';
		RD <= '1';
		if Done = '1' then
			Drd <= '1';
			Strobe <= '1';
			Dout <= '1';
		end if;
	 end if;
	 
	 if opcode = "01110" then 					-- Selecting Z4 or data loaded from memory
		mp5_sel <= '1';
	 else
		mp5_sel <='0';
	 end if;
	 
	 if opcode = "01111" then					-- if instruction is store
		Ain <= '1';
		WR <= '1';
		Dbus <= '1';
		Strobe <= '1';
		Dwr <= '1';
	 end if;	
end process;
end Behavioral;

