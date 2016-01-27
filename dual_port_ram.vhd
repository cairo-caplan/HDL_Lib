library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dual_port_ram is
	generic 
	(
		WORD_WIDTH		:	natural	:= 32;
		NR_LINES		:	natural := 1024
	);
	port (
		clk			: in std_logic;
		r_addr_i	: in natural range 0 to NR_LINES-1;
		w_addr_i	: in natural range 0 to NR_LINES-1;
		data_w_i	: in std_logic_vector((WORD_WIDTH-1) downto 0);
		we_i		: in std_logic;
		data_r_o	: out std_logic_vector((WORD_WIDTH -1) downto 0)
	);
end entity dual_port_ram;

architecture RTL of dual_port_ram is
	
	type mem_t is array(natural range <>) of std_logic_vector(WORD_WIDTH-1 downto 0);
	signal mem :	mem_t(0 to NR_LINES-1 );
begin
	
	sync_process :	process(clk)
	begin
		if(rising_edge(clk)) then 
			if(we_i = '1') then
				mem(w_addr_i) <= data_w_i;
			end if;
	 
			data_r_o <= mem(r_addr_i);
		end if;
	end process sync_process;
	
end architecture RTL;



