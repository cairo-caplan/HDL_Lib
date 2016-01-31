library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity fifo is
	generic (
		DATA_WIDTH	:	natural	:=	8;
		LENGTH	:	natural := 4
	);
	port (
		clk 	:	in std_logic;
		a_rst	:	in std_logic;
		rst 	:	in std_logic;
		we_i	:	in std_logic;
		d_i		:	in	std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
		re_i	:	in	std_logic;
		d_o		:	out	std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
		full_o	:	out	std_logic;
		empty_o	:	out	std_logic
		
	);
end entity fifo;

architecture RTL of fifo is
	type internal_data_t is array (natural range <>) of std_logic_vector(DATA_WIDTH-1 downto 0);
	
	signal internal_data	:	internal_data_t(0 to LENGTH -1) := (others=> (others=>'0'));
	signal	w_ptr, r_ptr	:	natural range 0 to LENGTH -1;
	signal looped			:	std_logic;

begin
	
	
	sync_process : process (clk, a_rst) is
	begin
		if a_rst = '1' then
			w_ptr <= 0;
			r_ptr <= 0;
			looped <= '0';
			full_o <= '0';
			empty_o <= '1';
			d_o <= (others=>'0'); 
		elsif rising_edge(clk) then
			if rst='1' then
				w_ptr <= 0;
				r_ptr <= 0;
				looped <= '0';
				full_o <= '0';
				empty_o <= '1';	
				d_o <= (others=>'0');
			else
				
				if we_i='1' then
					if looped='0' or w_ptr/=r_ptr then
						internal_data(w_ptr) <= d_i;
						
						if w_ptr = LENGTH -1 then
							w_ptr <= 0;
							looped <= '1';
						else
							w_ptr <= w_ptr + 1;
						end if;
					end if;
				end if;
				
				
				if re_i='1' then
					if looped='1' or w_ptr/=r_ptr then
						d_o <= internal_data(r_ptr);
						
						if r_ptr=LENGTH-1 then
							r_ptr<=0;
							looped <= '1';
						else
							r_ptr <= r_ptr + 1;
						end if;
					end if;
				end if;


				if (w_ptr = r_ptr) then
					if looped='1' then
						full_o <= '1';
					else
						empty_o <= '1';
					end if;
				else
					empty_o	<= '0';
					full_o	<= '0';
				end if;
			end if;
		end if;
	end process sync_process;
	

end architecture RTL;
