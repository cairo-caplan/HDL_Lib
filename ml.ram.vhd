library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
	generic(
		WORD_WIDTH		:	natural	:= 32;
		NR_LINES		:	natural := 1024
	);
	port (
		clk			:	in	std_logic;		
		we_i		:	in	std_logic;
		addr_i		:	in	natural range 0 to NR_LINES-1;
		data_w_i	:	in	std_logic_vector(WORD_WIDTH-1 downto 0);
		data_r_o	:	out	std_logic_vector(WORD_WIDTH-1 downto 0)
	);
end entity ram;

architecture RTL of ram is

	type mem_t is array(natural range <>) of std_logic_vector(WORD_WIDTH-1 downto 0);
	signal mem :	mem_t(0 to NR_LINES-1 );
	
begin
	
	sync_proc : process (clk) is
	begin
		if rising_edge(clk) then
			if we_i='1' then
				mem(addr_i) <= data_w_i;
			end if;
			data_r_o <= mem(addr_i);
		end if;
	end process sync_proc;
	
end architecture RTL;
